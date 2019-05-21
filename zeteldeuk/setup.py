from setuptools import setup


setup(
    name="zeteldeuk",
    version="0.1",
    description="Dotfile renderer",
    classifiers=[
        "Development Status :: 3 - Alpha",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3.7",
    ],
    url="http://github.com/maartenberg/zeteldeuk",
    author="Maarten van den Berg",
    author_email="mail@maartenberg.nl",
    license="MIT",
    packages=["zeteldeuk"],
    install_requires=["Jinja2", "click"],
    entry_points={"console_scripts": ["zeteldeuk-render=zeteldeuk.render:main"]},
    include_package_data=True,
    zip_safe=False,
)
