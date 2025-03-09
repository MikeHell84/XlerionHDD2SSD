## File Management 3D

## Description
File Management 3D is an application that provides a graphical interface for managing files and folders between an HDD and an SSD. It allows you to add folders and files, copy them to the SSD, copy them back to the HDD and select the destination folder on the SSD.

## Features
- Add Folder**: Add a folder to the source path list.
- Add File**: Add files to the source path list.
- Select SSD**: Selects the destination folder on the SSD.
- Delete SSD**: Deletes the selected SSD folder and restores the default folder.
- Copy to SSD**: Copies the selected files and folders to the SSD.
- Return to HDD**: Returns the files and folders from the SSD to the original locations.
- Open Location**: Opens the destination folder in File Explorer.
- Save Configuration**: Saves the current configuration to a JSON file.
- Open Configuration**: Loads a configuration from a JSON file.
- Clear**: Cleans the list of paths and added files.
- Exit**: Closes the application.

## Standards and Guidelines
- ISO 9001:2015** - Quality Management Systems.
- ISO/IEC 27001:2013** - Information Security Management Systems.
- ISO 31000:2018** - Risk Management.
- ISO 14001:2015** - Environmental Management Systems.
- ISO 45001:2018** - Occupational Health and Safety Management Systems.

## Developers.
- Miguel Rodriguez**: [redxlerion@gmail.com].
- **Xlerion**: [https://www.xlerion.com](https://www.xlerion.com)

## Program Potential
This program has the potential to significantly streamline file and folder management between HDDs and SSDs, improving efficiency and reducing manual effort. It can be particularly useful for users who need to transfer large amounts of data between different storage devices frequently.

## System Requirements
- Operating System**: Windows 7 or higher
- **PowerShell**: Version 5.1 or higher
- .NET Framework**: Version 4.5 or higher

## Installation
1. Clone the repository:
    ```sh
    git clone https://github.com/MikeHell84/XlerionHDD2SSD.git
    ```
2. Navigate to the project directory:
    ````sh
    cd XlerionHDD2SSD
    ```
3. Run the PowerShell script:
    ````sh
    .\FileManagement3D.ps1
    ```

## Compiling
To compile the PowerShell script into an executable (.exe) file, the `ps2exe` module was used. Here are the steps for compilation:
1. Install the `ps2exe` module if you don't have it:
    ````sh
    Install-Module -Name ps2exe -Scope CurrentUser
    ```
2. Run the following command to compile the script:
    ````sh
    Invoke-ps2exe -inputFile <your_path_>\XlerionHHD2SSDCache3D.ps1 -outputFile <you_path>\XlerionHHD2SSDCache.exe -iconFile x:\Data2Cache\DevFiles\Powershell\icon_16x16.ico -verbose
    ```

## Usage
1. Run the application.
2. Use the buttons and menus to manage your files and folders between the HDD and SSD.

## Contributions
Contributions are welcome. Please open an issue or send a pull request to discuss any changes you would like to make.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

Translated with DeepL.com (free version)