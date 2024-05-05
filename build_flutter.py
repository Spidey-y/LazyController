import subprocess
import shutil
import os


def build_flutter_app():
    os.chdir("./App")
    os.system("flutter build web --release")
    os.chdir("..")


def copy_build_to_web():
    if not os.path.exists("./web"):
        os.makedirs("./web")
    shutil.rmtree("./web")
    shutil.copytree("./App/build/web", "./web")


if __name__ == "__main__":
    build_flutter_app()
    copy_build_to_web()
    print("Build process completed successfully!")
