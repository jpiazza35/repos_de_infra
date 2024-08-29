import pkgutil

# Helper to load all files in this folder as submodules
# IMPORTANT dont put anything else more than model files here
__path__ = pkgutil.extend_path(__path__, __name__)
for importer, modname, ispkg in pkgutil.walk_packages(path=__path__, prefix=__name__ + '.'):
    __import__(modname)
