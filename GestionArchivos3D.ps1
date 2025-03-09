# File Management 3D
# This script provides a graphical interface to manage files and folders between an HDD and an SSD.
# It allows adding folders and files, copying them to the SSD, returning them to the HDD, and selecting the destination SSD.

# Load the Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

$scriptPath = "Powershell\GestionArchivos3D.ps1"
$outputExePath = "Powershell\XlerionHDD2SSD\Xlerion - HDD 2 SSD Cache.exe"
$iconPath = "Powershell\XlerionHDD2SSD\icons\icon_64x64.ico"

# Check if the icon file exists
if (Test-Path $iconPath) {
    Write-Host "The icon file exists at the specified path."
} else {
    Write-Host "The icon file does not exist at the specified path."
}

# Compile the PowerShell script into an .exe file with an icon
try {
    Invoke-ps2exe -inputFile $scriptPath -outputFile $outputExePath -iconFile $iconPath -verbose
} catch {
    Write-Host "Error during compilation: $_"
}

# Create the main window
$form = New-Object System.Windows.Forms.Form
$form.Text = "Xlerion - HDD to SSD"
$form.Size = New-Object System.Drawing.Size(800, 600)  # Set a reasonable initial size
$form.MinimumSize = New-Object System.Drawing.Size(800, 600)  # Set a minimum size to prevent it from being too small
$form.StartPosition = "CenterScreen"
$form.AutoSize = $true
$form.AutoSizeMode = "GrowAndShrink"
$form.BackColor = [System.Drawing.Color]::Black  # Set background color to black
$form.ForeColor = [System.Drawing.Color]::White  # Set text color to white

# Load the background image
$backgroundImagePath = "Powershell\XlerionHDD2SSD\background.png"
if (Test-Path $backgroundImagePath) {
    $backgroundImage = [System.Drawing.Image]::FromFile($backgroundImagePath)
    $form.BackgroundImage = $backgroundImage
    $form.BackgroundImageLayout = "Stretch"
    # Adjust the form size to match the background image size
    $form.Size = New-Object System.Drawing.Size($backgroundImage.Width, $backgroundImage.Height)
    $form.MinimumSize = New-Object System.Drawing.Size($backgroundImage.Width, $backgroundImage.Height)
} else {
    Write-Host "The background image does not exist at the specified path."
}

# Create a panel to hold the text box and progress bar
$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = [System.Windows.Forms.DockStyle]::Fill
$panel.BackColor = [System.Drawing.Color]::Transparent  # Ensure the panel is transparent to show the background
$form.Controls.Add($panel)

# Create a TableLayoutPanel to manage the layout
$tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
$tableLayoutPanel.ColumnCount = 1
$tableLayoutPanel.RowCount = 4
$tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 200)))  # TextBox row
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 40)))   # ProgressBar row
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))  # ButtonPanel row
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 30)))  # Menu row
$panel.Controls.Add($tableLayoutPanel)

# Create the text box for displaying command prompts
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Multiline = $true
$textBox.ScrollBars = "Vertical"
$textBox.Dock = [System.Windows.Forms.DockStyle]::Fill
$textBox.BackColor = [System.Drawing.Color]::Black  # Set background color to black
$textBox.ForeColor = [System.Drawing.Color]::Cyan  # Set text color to bright blue
$tableLayoutPanel.Controls.Add($textBox, 0, 0)

# Create the progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Dock = [System.Windows.Forms.DockStyle]::Fill
$tableLayoutPanel.Controls.Add($progressBar, 0, 1)

# Create a panel to hold the buttons with padding
$buttonPanelContainer = New-Object System.Windows.Forms.Panel
$buttonPanelContainer.Dock = [System.Windows.Forms.DockStyle]::Fill
$buttonPanelContainer.Padding = New-Object System.Windows.Forms.Padding(50)  # Add padding to center the button panel
$buttonPanelContainer.BackColor = [System.Drawing.Color]::Transparent
$tableLayoutPanel.Controls.Add($buttonPanelContainer, 0, 2)

# Create a panel to hold the buttons
$buttonPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$buttonPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
$buttonPanel.BackColor = [System.Drawing.Color]::Transparent
$buttonPanel.FlowDirection = [System.Windows.Forms.FlowDirection]::LeftToRight
$buttonPanel.WrapContents = $true
$buttonPanelContainer.Controls.Add($buttonPanel)

# Create the menu
$menu = New-Object System.Windows.Forms.MenuStrip
$form.MainMenuStrip = $menu
$tableLayoutPanel.Controls.Add($menu, 0, 3)

# Create the file menu
$fileMenu = New-Object System.Windows.Forms.ToolStripMenuItem("File")
$menu.Items.Add($fileMenu)

# Create the submenu to save the configuration
$saveConfigMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("Save Configuration")
$fileMenu.DropDownItems.Add($saveConfigMenuItem)

# Create the submenu to open the configuration
$openConfigMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("Open Configuration")
$fileMenu.DropDownItems.Add($openConfigMenuItem)

# Create the help menu
$helpMenu = New-Object System.Windows.Forms.ToolStripMenuItem("Help")
$menu.Items.Add($helpMenu)

# Create the information submenu
$infoMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("Information")
$helpMenu.DropDownItems.Add($infoMenuItem)

# Action to show information
$infoMenuItem.Add_Click({
    $infoText = @"
This application allows you to manage files and folders between an HDD and an SSD.

Features:
1. Add Folder: Adds a folder to the list of source paths.
2. Add File: Adds files to the list of source paths.
3. Select SSD: Selects the destination SSD folder.
4. Remove SSD: Removes the selected SSD folder and resets to the default folder.
5. Copy to SSD: Copies the selected files and folders to the SSD.
6. Return to HDD: Returns the files and folders from the SSD to the original locations.
7. Open Location: Opens the destination folder in File Explorer.
8. Save Configuration: Saves the current configuration to a JSON file.
9. Open Configuration: Loads a configuration from a JSON file.
10. Clear: Clears the list of added paths and files.
11. Exit: Closes the application.

Developers:
- Miguel Rodriguez: redxlerion@gmail.com
- Xlerion: https://www.xlerion.com


Potential of the Program:
This program has the potential to significantly streamline the management of files and folders between HDDs and SSDs, improving efficiency and reducing manual effort. It can be particularly useful for users who frequently need to transfer large amounts of data between different storage devices.
"@

    [System.Windows.Forms.MessageBox]::Show($infoText, "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})

# Action to save the configuration
$saveConfigMenuItem.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "JSON files (*.json)|*.json|All files (*.*)|*.*"
    $saveFileDialog.InitialDirectory = [System.Environment]::GetFolderPath("MyDocuments")
    if ($saveFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $config = @{
            RutasOrigen = $global:rutasOrigen
            Destino = $global:destino
        }
        $config | ConvertTo-Json | Set-Content -Path $saveFileDialog.FileName
        [System.Windows.Forms.MessageBox]::Show("Configuration saved to $($saveFileDialog.FileName)", "Information")
    }
})

# Action to open the configuration
$openConfigMenuItem.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "JSON files (*.json)|*.json|All files (*.*)|*.*"
    $openFileDialog.InitialDirectory = [System.Environment]::GetFolderPath("MyDocuments")
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $config = Get-Content -Path $openFileDialog.FileName | ConvertFrom-Json
        $global:rutasOrigen = $config.RutasOrigen
        $global:destino = $config.Destino
        $textBox.Clear()
        foreach ($ruta in $global:rutasOrigen) {
            $textBox.AppendText("Loaded path: $ruta`r`n")
        }
        [System.Windows.Forms.MessageBox]::Show("Configuration loaded from $($openFileDialog.FileName)", "Information")
    }
})

# Function to return files and delete them from the SSD
function DevolverArchivoOCarpeta {
    param (
        [string]$ruta
    )
    if (Test-Path $ruta) {
        try {
            Write-Host "Returning files to: $ruta from $global:destino"  # Debug message
            # Move the files to the destination
            $items = Get-ChildItem -Path $global:destino
            $totalItems = $items.Count
            $progressBar.Value = 0
            $startTime = Get-Date
            foreach ($index in 0..($totalItems - 1)) {
                $item = $items[$index]
                Copy-Item -Path $item.FullName -Destination $ruta -Force
                Remove-Item -Path $item.FullName -Force
                $textBox.AppendText("File/folder moved: $item`r`n")
                $progressBar.Value = [math]::Round((($index + 1) / $totalItems) * 100)
                $elapsedTime = (Get-Date) - $startTime
                $remainingTime = $elapsedTime.TotalSeconds / ($index + 1) * ($totalItems - $index - 1)
                $form.Text = "File Management 3D - Remaining time: $([math]::Round($remainingTime)) seconds"
            }

            $textBox.AppendText("All files were removed from the SSD after being returned.`r`n")
        } catch {
            $textBox.AppendText("Error returning to: $ruta. Details: $_`r`n")
            Write-Host "Error returning to: $ruta. Details: $_"  # Debug message
        }
    } else {
        $textBox.AppendText("Path does not exist: $ruta`r`n")
        Write-Host "Path does not exist: $ruta"  # Debug message
    }
    $form.Text = "File Management 3D"
}

# Load button background image
$buttonBackgroundImagePath = "x:\Data2Cache\DevFiles\Powershell\button_background.png"
$buttonBackgroundImage = $null
if (Test-Path $buttonBackgroundImagePath) {
    $buttonBackgroundImage = [System.Drawing.Image]::FromFile($buttonBackgroundImagePath)
} else {
    Write-Host "The button background image does not exist at the specified path."
}

# Load button background images
$buttonImages = @{
    "Add Folder" = "Powershell\XlerionHDD2SSD\icons\add_folder.png"
    "Add File" = "Powershell\XlerionHDD2SSD\icons\add_file.png"
    "Copy to SSD" = "Powershell\XlerionHDD2SSD\icons\copy_to_ssd.png"
    "Return to HDD" = "Powershell\XlerionHDD2SSD\icons\return_to_hdd.png"
    "Select SSD" = "Powershell\XlerionHDD2SSD\icons\select_ssd.png"
    "Remove SSD" = "Powershell\XlerionHDD2SSD\icons\remove_ssd.png"
    "Open Location" = "Powershell\XlerionHDD2SSD\icons\open_location.png"
    "Exit" = "Powershell\XlerionHDD2SSD\icons\exit.png"
}

# Create the buttons with only the image and adjust size to fit the image
function CreateButton($text) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $text
    $button.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter  # Center text horizontally and vertically
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $button.FlatAppearance.BorderSize = 0
    $button.BackColor = [System.Drawing.Color]::Transparent
    $button.ForeColor = [System.Drawing.Color]::Cyan  # Set text color to bright blue
    $button.Font = New-Object System.Drawing.Font($button.Font, [System.Drawing.FontStyle]::Bold)  # Set text to bold
    if ($buttonImages[$text] -ne $null -and (Test-Path $buttonImages[$text])) {
        $image = [System.Drawing.Image]::FromFile($buttonImages[$text])
        $button.BackgroundImage = $image
        $button.BackgroundImageLayout = "Stretch"
        $button.Size = New-Object System.Drawing.Size($image.Width, $image.Height)  # Adjust size to fit the image
    }
    return $button
}

$btnAddFolder = CreateButton "Add Folder"
$buttonPanel.Controls.Add($btnAddFolder)

$btnAddFile = CreateButton "Add File"
$buttonPanel.Controls.Add($btnAddFile)

$btnCopiar = CreateButton "Copy to SSD"
$buttonPanel.Controls.Add($btnCopiar)

$btnDevolver = CreateButton "Return to HDD"
$buttonPanel.Controls.Add($btnDevolver)

$btnElegirSSD = CreateButton "Select SSD"
$buttonPanel.Controls.Add($btnElegirSSD)

$btnQuitarSSD = CreateButton "Remove SSD"
$buttonPanel.Controls.Add($btnQuitarSSD)

$btnAbrirUbicacion = CreateButton "Open Location"
$buttonPanel.Controls.Add($btnAbrirUbicacion)

$btnSalir = CreateButton "Exit"
$buttonPanel.Controls.Add($btnSalir)

# Action to add folder
$btnAddFolder.Add_Click({
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $global:rutasOrigen += $folderDialog.SelectedPath
        $textBox.AppendText("Added folder: $($folderDialog.SelectedPath)`r`n")
    }
})

# Action to add file
$btnAddFile.Add_Click({
    $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $fileDialog.Multiselect = $true
    if ($fileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $global:rutasOrigen += $fileDialog.FileNames
        foreach ($file in $fileDialog.FileNames) {
            $textBox.AppendText("Added file: $file`r`n")
        }
    }
})

# Action to copy files/folders to the SSD
$btnCopiar.Add_Click({
    if ($global:rutasOrigen.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("No paths or files configured. Add paths/files first.", "Warning")
    } else {
        $totalItems = $global:rutasOrigen.Count
        $progressBar.Value = 0
        $startTime = Get-Date
        foreach ($index in 0..($totalItems - 1)) {
            $ruta = $global:rutasOrigen[$index]
            if (Test-Path $ruta) {
                try {
                    Write-Host "Copying from: $ruta to $global:destino"
                    if (-not (Test-Path $global:destino)) {
                        Write-Host "Creating destination folder: $global:destino"
                        New-Item -ItemType Directory -Path $global:destino
                    }
                    Copy-Item -Path "$ruta" -Destination $global:destino -Recurse -Force
                    $textBox.AppendText("Files/folders copied from: $ruta`r`n")
                    $progressBar.Value = [math]::Round((($index + 1) / $totalItems) * 100)
                    $elapsedTime = (Get-Date) - $startTime
                    $remainingTime = $elapsedTime.TotalSeconds / ($index + 1) * ($totalItems - $index - 1)
                    $form.Text = "File Management 3D - Remaining time: $([math]::Round($remainingTime)) seconds"
                } catch {
                    $textBox.AppendText("Error copying from: $ruta. Details: $_`r`n")
                    Write-Host "Error copying from: $ruta. Details: $_"
                }
            } else {
                $textBox.AppendText("Path does not exist: $ruta`r`n")
                Write-Host "Path does not exist: $ruta"
            }
        }
        [System.Windows.Forms.MessageBox]::Show("Files and folders successfully copied to SSD.", "Success")
        $form.Text = "File Management 3D"
    }
})

# Action to return files/folders to the HDD
$btnDevolver.Add_Click({
    if ($global:rutasOrigen.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("No paths or files configured. Add paths/files first.", "Warning")
    } else {
        foreach ($ruta in $global:rutasOrigen) {
            DevolverArchivoOCarpeta -ruta $ruta
        }
        [System.Windows.Forms.MessageBox]::Show("Files and folders successfully returned to HDD.", "Success")
    }
})

# Action to select the SSD
$btnElegirSSD.Add_Click({
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $global:destino = $folderDialog.SelectedPath
        [System.Windows.Forms.MessageBox]::Show("SSD selected: $global:destino", "Information")
    }
})

# Action to remove the SSD
$btnQuitarSSD.Add_Click({
    if (Test-Path $global:destino) {
        Remove-Item -Path $global:destino -Recurse -Force
        [System.Windows.Forms.MessageBox]::Show("Destination folder removed: $global:destino", "Information")
    }
    $global:destino = "C:\CarpetaSSD"
    [System.Windows.Forms.MessageBox]::Show("SSD deselected. Using default folder: $global:destino", "Information")
})

# Action to open the location of the files or folders
$btnAbrirUbicacion.Add_Click({
    if (Test-Path $global:destino) {
        Start-Process explorer.exe $global:destino
    } else {
        [System.Windows.Forms.MessageBox]::Show("Destination folder does not exist.", "Error")
    }
})

# Action to exit
$btnSalir.Add_Click({
    $form.Close()
})

# Show the window
[void]$form.ShowDialog()