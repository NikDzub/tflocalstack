import os


def create_file_structure(project_name):
    # Define variable names
    modules_dir = "modules"
    vpc_module = "vpc"
    subnets_module = "subnets"
    nat_gateway_module = "nat_gateway"
    security_groups_module = "security_groups"
    environments_dir = "environments"
    development_env = "development"

    # Create main project directory
    os.makedirs(project_name)

    # Create modules directory
    modules_path = os.path.join(project_name, modules_dir)
    os.makedirs(modules_path)

    # Create vpc module directory
    vpc_module_path = os.path.join(modules_path, vpc_module)
    os.makedirs(vpc_module_path)

    # Create subnets module directory
    subnets_module_path = os.path.join(modules_path, subnets_module)
    os.makedirs(subnets_module_path)

    # Create nat_gateway module directory
    nat_gateway_module_path = os.path.join(modules_path, nat_gateway_module)
    os.makedirs(nat_gateway_module_path)

    # Create security_groups module directory
    security_groups_module_path = os.path.join(modules_path, security_groups_module)
    os.makedirs(security_groups_module_path)

    # Create environments directory
    environments_path = os.path.join(project_name, environments_dir)
    os.makedirs(environments_path)

    # Create development environment directory
    development_path = os.path.join(environments_path, development_env)
    os.makedirs(development_path)

    # Create top-level directory files
    top_level_files = [
        "main.tf",
        "variables.tf",
        "outputs.tf",
        "terraform.tfvars",
        ".terraformignore",
    ]

    for file in top_level_files:
        file_path = os.path.join(project_name, file)
        open(file_path, "a").close()  # Create empty files

    # Create main.tf, variables.tf, outputs.tf in each module directory
    module_files = ["main.tf", "variables.tf", "outputs.tf"]

    for directory in [
        vpc_module_path,
        subnets_module_path,
        nat_gateway_module_path,
        security_groups_module_path,
    ]:
        for file in module_files:
            file_path = os.path.join(directory, file)
            open(file_path, "a").close()  # Create empty files

    # Create main.tf, variables.tf, outputs.tf, terraform.tfvars, .terraformignore in each environment directory
    environment_files = [
        "main.tf",
        "variables.tf",
        "outputs.tf",
        "terraform.tfvars",
        ".terraformignore",
    ]

    for file in environment_files:
        file_path = os.path.join(development_path, file)
        open(file_path, "a").close()  # Create empty files


if __name__ == "__main__":
    project_name = "terraform_project"
    create_file_structure(project_name)
    print(f"File structure created for the '{project_name}' project.")
