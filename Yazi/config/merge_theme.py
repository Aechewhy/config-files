import toml
import os

# Paths for Yazi configuration
user_config_dir = os.path.expanduser(r"C:\Users\LENOVO LEGION\AppData\Roaming\yazi")
theme_path = os.path.join(user_config_dir, "theme.toml")
flavors_dir = os.path.join(user_config_dir, "flavors")

# Specify the flavor you want to use
flavor_name = "sunset.yazi"
flavor_path = os.path.join(flavors_dir, flavor_name, "flavor.toml")

# Load flavor.toml
if os.path.exists(flavor_path):
    flavor = toml.load(flavor_path)
else:
    raise FileNotFoundError(f"Flavor file not found: {flavor_path}")

# Load user's theme.toml
if os.path.exists(theme_path):
    theme = toml.load(theme_path)
else:
    theme = {}

# Merge with flavor.toml taking precedence
merged = {**theme, **flavor}  # Flavor values override theme values

# Save the merged configuration back to theme.toml
with open(theme_path, "w") as f:
    toml.dump(merged, f)

print(f"Merged configuration saved to {theme_path}. Flavor '{flavor_name}' was prioritized.")
