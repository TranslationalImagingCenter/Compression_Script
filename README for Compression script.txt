README: Instructions for Using the 7-Zip Zstandard Compression Script

==========================================================
1. Overview
==========================================================

This script compresses individual files in the current folder and all subfolders using the Zstandard (zstd) compression algorithm. It ensures data integrity through checksum validation and logs all actions for review.

This script has been tested on:
- Windows using the 7-Zip Zstandard fork
- Mac OS (14.7) using the native `zstd` compression tool

==========================================================
2. Prerequisites
==========================================================

To use this script, you need to install the appropriate compression tools based on your operating system:

- Windows: Install 7-Zip Zstandard
- Mac OS: Install Zstandard (zstd) via Homebrew

==========================================================
Windows Instructions
==========================================================

----------------------------------------------------------
3. Installation Instructions (Windows)
----------------------------------------------------------

Step 1: Download 7-Zip Zstandard
- Visit the official repository: https://github.com/mcmilk/7-Zip-zstd/releases
- Download the latest version for your operating system (e.g., `7z-x64.exe` for 64-bit Windows)

Step 2: Install 7-Zip Zstandard
- Run the installer and follow the on-screen instructions.
- By default, it installs to:
  C:\Program Files\7-Zip-Zstandard\
- Ensure that `7z.exe` is present in the installation folder.

----------------------------------------------------------
4. Script Configuration (Windows)
----------------------------------------------------------

Step 1: Adjust the 7-Zip Path (if necessary)
- If you installed 7-Zip Zstandard in a different folder, update the script.
- Open the script in a text editor (e.g., Notepad).
- Locate the following line:

  SET "7ZIP_PATH=C:\Program Files\7-Zip-Zstandard\7z.exe"

- Replace it with the actual path where `7z.exe` is installed.
  Example:
  SET "7ZIP_PATH=D:\CustomFolder\7-Zip-Zstandard\7z.exe"

Step 2: Save the Script
- Ensure the script is saved with a .bat extension (e.g., `compress_7zip_std.bat`).

----------------------------------------------------------
5. Usage Instructions (Windows)
----------------------------------------------------------

Step 1: Place the Script in the Desired Folder
- Move the script (`compress_7zip_std.bat`) to the folder where you want to compress files.
- The script will process all files in the folder and subfolders.

Step 2: Run the Script
- Double-click the script to run it.
- Follow the on-screen instructions:
  - Read the description and legal disclaimer.
  - Type Y to proceed or N to exit.

Step 3: Review the Log File
- After the script completes, check the log file (`compression_log_DATE.txt`) in the same folder for:
  - Successfully compressed files
  - Files that were already compressed and skipped
  - Any errors encountered during compression or validation

==========================================================
Mac OS Instructions (Tested on Mac OS 14.7)
==========================================================

----------------------------------------------------------
3. Installation Instructions (Mac OS)
----------------------------------------------------------

Step 1: Install Zstandard (`zstd`)
Mac OS does not support 7-Zip with Zstandard natively, so we use Zstandard (`zstd`) instead.

To install `zstd`, run:
  brew install zstd

Step 2: Save the Mac Script
1. Open Terminal and navigate to the desired folder:
   cd /path/to/your/folder

2. Create the script:
   nano compress_zstd.sh

3. Copy and paste the Mac-compatible script into Nano.
4. Save the script (Ctrl + X, then Y, then Enter).

Step 3: Make the Script Executable
  chmod +x compress_zstd.sh

----------------------------------------------------------
4. Usage Instructions (Mac OS)
----------------------------------------------------------

Step 1: Place the Script in the Desired Folder
- Move `compress_zstd.sh` to the folder where you want to compress files.
- The script will process all files in the folder and subfolders.

Step 2: Run the Script
- Open Terminal and navigate to the folder:
   cd /path/to/your/folder

- Run the script:
   ./compress_zstd.sh

Step 3: Review the Log File
- After the script completes, check the log file (`compression_log_DATE.txt`) in the same folder for:
  - Successfully compressed files
  - Files that were already compressed and skipped
  - Errors encountered during compression or validation

==========================================================
6. Notes and Recommendations
==========================================================

1. Ensure Backups:
- Always back up your data before running the script.

2. Technical Competence:
- The script is intended for users familiar with file compression and automation.
- If unsure, seek assistance from a technically competent individual.

3. Test on a Small Dataset:
- Before using the script on a large set of files, test it on a small subset to ensure it works as expected.

==========================================================
7. Troubleshooting
==========================================================

1. Windows: 7-Zip Path Error
- If the script cannot find `7z.exe`, ensure the path set in the script matches the installation folder of 7-Zip Zstandard.

2. Windows: Permission Issues
- Run the script as Administrator if it encounters permission errors.

3. Windows: Corrupted Compressed Files
- If a `.zst` file is flagged as corrupted, manually verify it and re-compress if necessary.

4. Mac: `zstd` Command Not Found
- Ensure that Zstandard (`zstd`) is installed by running:
   which zstd

- If it returns no output, install it using:
   brew install zstd

5. Mac: Script Permission Denied
- If you see a permission error when running `./compress_zstd.sh`, make it executable:
   chmod +x compress_zstd.sh

==========================================================
8. Legal Disclaimer
==========================================================

This script is provided "as is," without any express or implied warranties, including but not limited to the implied warranties of merchantability, fitness for a particular purpose, or non-infringement.

By using this script, you acknowledge and agree that:
- You assume full responsibility for the use of this script and any outcomes or consequences resulting from its execution.
- The developers and distributors bear no liability for any loss, damage, or corruption of data, systems, or devices resulting from the use or misuse of this script.
- You are solely responsible for ensuring that this script is used in compliance with all applicable laws, regulations, and organizational policies.

This script is intended for technically competent individuals who understand the risks associated with file compression and automation.

By continuing to use this script, you accept these terms and acknowledge that any use is at your own risk.

==========================================================
Final Notes
==========================================================

- For Windows users, refer to the 7-Zip Zstandard GitHub page:
  https://github.com/mcmilk/7-Zip-zstd

- For Mac users, refer to the Zstandard documentation:
  https://facebook.github.io/zstd/

Happy compressing!