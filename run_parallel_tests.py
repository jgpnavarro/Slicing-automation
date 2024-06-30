import argparse
import configparser
import os
import subprocess

class CaseSensitiveConfigParser(configparser.ConfigParser):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.optionxform = str  # Mantiene las mayúsculas y minúsculas

def create_devices_config():
    config = CaseSensitiveConfigParser()
    config.read('DevicesSet.txt')

    current_directory = os.path.dirname(os.path.realpath(__file__))
    argument_files = []

    for i, section in enumerate(config.sections(), 1):
        filename = os.path.join(current_directory, f'Device{i}.txt')
        with open(filename, 'w') as file:
            for key in config[section]:
                value = config[section][key]
                file.write(f"--variable {key}:{value}\n")
        argument_files.append(filename)

    return argument_files, len(config.sections())


def execute_pabot_tests(argument_files, number_of_sections, test_path):
    free_port = 8817
    command = ['pabot', '--pabotlibport', str(free_port), '--verbose', '--pabotlib', '--processes', str(number_of_sections)]
    
    # Add each argument file with a specific number
    for i, arg_file in enumerate(argument_files, 1):
        command.extend([f'--argumentfile{i}', arg_file])

    command.extend(['--outputdir', './Output', test_path])

    # Execute the command
    subprocess.run(command)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Run Pabot tests.')
    parser.add_argument('test_path', type=str, help='The path to the test suite to execute (e.g., ./Tests/SpeedTestApp.robot).')
    args = parser.parse_args()

    argument_files, number_of_sections = create_devices_config()
    execute_pabot_tests(argument_files, number_of_sections, args.test_path)
