"""The refactoring which is very week 
"""

from pathlib import Path
import shutil
import ast
from dataclasses import dataclass

ReplacePair = tuple[str, str, bool]


@dataclass
class ChangeOperation:
    """It states how to change the `import sentence` or `from ... import` sentence."""

    original_uri: str  # Like `fastapi.application`
    new_uri: str  # Like `fastapi.revised_application`


@dataclass
class ImportSentence:
    filepath: Path
    lineno: int
    end_lineno: int
    name: str
    asname: str | None = None

    def is_related_uri_path(self, uri_path: str) -> bool:
        """
        `uri_path` is like "fastapi.application".

        If this class is related to `uri_path`, i.e.,
        if `uri_path` dissapears, the import does not work,
        then this function returns `True`
        """
        parts = self.name.split(".")
        query_parts = uri_path.split(".")
        if len(parts) < len(query_parts):
            return False
        for i, elem in enumerate(query_parts):
            if parts[i] != elem:
                return False
        return True

    def rename(self, ch_op: ChangeOperation):
        text = self.filepath.read_text()
        lines = text.split("\n")
        assert self.lineno == self.end_lineno
        orig_uri = ch_op.original_uri
        ln = self.lineno - 1
        assert lines[ln].find(ch_op.original_uri) != -1
        lines[ln] = lines[ln].replace(ch_op.original_uri, ch_op.new_uri)
        self.filepath.write_text("\n".join(lines))

    @property
    def uri(self):
        return self.name


@dataclass
class ImportFromSentence:
    filepath: Path
    lineno: int
    end_lineno: int
    from_module: str
    name: str
    asname: str | None = None

    def is_related_uri_path(self, uri_path: str) -> bool:
        """
        `uri_path` is like "fastapi.application".

        If this class is related to `uri_path`, i.e.,
        if `uri_path` dissapears, the import does not work,
        then this function returns `True`
        """
        parts = self.from_module.split(".") + [self.name]
        query_parts = uri_path.split(".")
        if len(parts) < len(query_parts):
            return False
        for i, elem in enumerate(query_parts):
            if parts[i] != elem:
                return False
        return True

    def rename(self, ch_op: ChangeOperation):
        parts = self.from_module.split(".") + [self.name]
        ch_parts = ch_op.original_uri.split(".")
        if parts == ch_parts:
            # Entire parts are fitting.

            # Rewrite the parts of `from ...`
            pairs: list[ReplacePair] = []
            previous = self.from_module
            after = ".".join(ch_op.new_uri.split(".")[:-1])
            pairs.append((previous, after, True))
            pairs.append((self.name, ch_op.new_uri.split(".")[-1], False))
            self.replace(pairs)
            return
        else:
            # In case of partial match, it is sure that
            # the `name` is not required to override.
            assert len(ch_parts) <= len(parts)
            assert (
                ch_elem == elem for ch_elem, elem in zip(ch_parts, parts)
            ), "From Construction"

            previous = self.from_module
            after = ".".join(
                (ch_op.new_uri.split(".") + parts[len(ch_parts) : -1])
            )  # Exclude `self.name`
            pair = (previous, after, True)
            self.replace([pair])
            return

        assert False, "Not yet"

        is_rewriting_name = None

    def replace(self, pairs: ReplacePair):
        """[NOTE]: If the `same` name is used for
        packages, then what this funtion does is different from
        our intention.
        """

        text = self.filepath.read_text()
        lines = text.split("\n")
        s_ln = self.lineno - 1
        e_ln = self.end_lineno - 1
        targets = lines[s_ln : e_ln + 1]
        string = "".join(targets)
        for pair in pairs:
            previous, after, is_forward = pair
            assert string.find(previous) != -1
            if is_forward:
                string = string.replace(previous, after, 1)
            else:
                # [TODO]: Introduce rreplace.
                string = string.replace(previous, after, 1)
                print("replace is Done", previous, after)
        lines[s_ln : e_ln + 1] = string.split("\n")
        self.filepath.write_text("\n".join(lines))


class Package:
    """This class represents an package.

    Note that this class does not handle the case
    where multiple packages exist in the one project.
    """

    def __init__(self, root_folder: Path):
        assert root_folder.exists()
        self.root_folder = Path(root_folder)
        self.package_name = self.root_folder.name

    def get_package_uri(self, path: Path) -> str:
        # Such as `fastapi.application`
        path = Path(path)
        if path.name == "__init__.py":
            path = path.parent

        relpath = path.relative_to(self.root_folder)
        if path.is_dir():
            name = ".".join([self.package_name] + list(relpath.parts))
        else:
            name = ".".join(
                [self.package_name] + list(relpath.parts[:-1]) + [relpath.stem]
            )
        return name

    def get_related_usages(
        self, path
    ) -> tuple[list[ImportSentence], list[ImportFromSentence]]:
        import_sentences = []
        import_from_sentences = []
        for py_file in self.python_files:
            i_sentences, f_sentences = self.get_import_related_info(py_file)
            uri_path = self.get_package_uri(path)

            i_sentences = [
                elem for elem in i_sentences if elem.is_related_uri_path(uri_path)
            ]
            f_sentences = [
                elem for elem in f_sentences if elem.is_related_uri_path(uri_path)
            ]
            import_sentences += i_sentences
            import_from_sentences += f_sentences
        return import_sentences, import_from_sentences

    def get_import_related_info(
        self, filepath: Path
    ) -> tuple[list[ImportSentence], list[ImportFromSentence]]:
        source = Path(filepath).read_text()
        tree = ast.parse(source, str(filepath))
        imports = []
        froms = []

        for node in ast.walk(tree):
            if isinstance(node, ast.Import):
                for alias in node.names:
                    elem = ImportSentence(
                        filepath, node.lineno, node.end_lineno, alias.name, alias.asname
                    )
                    imports.append(elem)
            elif isinstance(node, ast.ImportFrom):
                module = node.module or ""
                for alias in node.names:
                    elem = ImportFromSentence(
                        filepath,
                        node.lineno,
                        node.end_lineno,
                        module,
                        alias.name,
                        alias.asname,
                    )
                    froms.append(elem)
        return imports, froms

    @property
    def python_files(self) -> list[Path]:
        return [path for path in self.root_folder.glob("**/*.py")]

    @classmethod
    def from_an_project_file(cls, path) -> "Package":
        path = Path(path)

        def _is_inside_package(folder: Path):
            return (folder / "__init__.py").exists()

        if not path.is_dir():
            folder = path.parent
        else:
            folder = path
        assert _is_inside_package(folder)

        while True:
            if not _is_inside_package(folder.parent):
                return cls(folder)
            folder = folder.parent

    def refactor_file_move(self, old_path: Path, new_path: Path):
        """Rewrite the `import` sentences based on the rename of files
        inside the project.
        """
        old_path = Path(old_path)
        new_path = Path(new_path)
        old_uri = self.get_package_uri(old_path)
        new_uri = self.get_package_uri(new_path)

        assert old_path.exists()
        im_sentences, from_sentences = self.get_related_usages(old_path)
        ch_op = ChangeOperation(old_uri, new_uri)
        for elem in im_sentences:
            elem.rename(ch_op)

        for elem in from_sentences:
            elem.rename(ch_op)

        # Move the files.
        shutil.move(old_path, new_path)
        #os.remove(old_path)


if __name__ == "__main__":
    pass
    target_path = Path(
        r"./test_package\subA\source.py"
    )
    after_path = (
        r"./test_package\subA\sourceAFT.py"
    )
    package = Package.from_an_project_file(target_path)

    u1, u2 = package.get_related_usages(target_path)
    package.refactor_file_move(target_path, after_path)
    # package.refactor_file_move(after_path, target_path)
