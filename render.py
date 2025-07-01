import os
from jinja2 import Template

def load_env(filename=".env.local"):
    with open(filename) as f:
        for line in f:
            if line.strip() and not line.startswith('#'):
                key, val = line.strip().split('=', 1)
                os.environ[key] = val

load_env()

with open("./dockerfiles/judge/Config.pm.template") as f:
    template = Template(f.read())

with open("./dockerfiles/judge/Config.pm", "w") as f:
    f.write(template.render(os.environ))

with open("./dockerfiles/judge/local.xml.template") as f:
    template = Template(f.read())

with open("./dockerfiles/judge/local.xml", "w") as f:
    f.write(template.render(os.environ))
