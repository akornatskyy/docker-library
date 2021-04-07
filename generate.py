import json
import os.path
from wheezy.template.engine import Engine
from wheezy.template.ext.core import CoreExtension
from wheezy.template.loader import FileLoader

engine = Engine(
    loader=FileLoader(["."]), extensions=[CoreExtension(line_join="")]
)

config = json.load(open("generate.json"))
for t in config["targets"]:
    template = engine.get_template(
        os.path.join(t["base"], "Dockerfile.template")
    )
    defaults = t.get("defaults", {})
    for variant in t["variants"]:
        context = dict(defaults, **variant["context"])
        content = template.render(context)
        out = os.path.join(t["base"], variant["out"], "Dockerfile")
        with open(out, "w", newline="\r\n") as f:
            f.write(content)
