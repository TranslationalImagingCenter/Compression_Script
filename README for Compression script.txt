README: Instructions for Using the 7-Zip Zstandard Compression Script

1. Overview

This script compresses individual files in the current folder and all subfolders using the Zstandard (zstd) compression algorithm implemented in the 7-Zip Zstandard fork. It ensures data integrity through checksum validation and logs all actions for review.

2. Prerequisites

To use this script, you need to install the 7-Zip Zstandard fork and ensure it is accessible on your system.

3. Installation Instructions
	1.	Download 7-Zip Zstandard:
	•	Visit the official repository: https://github.com/mcmilk/7-Zip-zstd/releases.
	•	Download the latest version for your operating system (e.g., 7z-x64.exe for 64-bit Windows).
	2.	Install 7-Zip Zstandard:
	•	Run the installer and follow the on-screen instructions.
	•	By default, it installs to:

C:\Program Files\7-Zip-Zstandard\


	•	Ensure that the 7z.exe file is present in the installation folder.

4. Script Configuration
	1.	Adjust the 7-Zip Path (if necessary):
	•	If you installed 7-Zip Zstandard in a folder other than the default (C:\Program Files\7-Zip-Zstandard), you must update the script.
	•	Open the script in a text editor (e.g., Notepad).
	•	Locate the following line:

SET "7ZIP_PATH=C:\Program Files\7-Zip-Zstandard\7z.exe"


	•	Replace C:\Program Files\7-Zip-Zstandard\7z.exe with the full path to 7z.exe on your system.
Example:

SET "7ZIP_PATH=D:\CustomFolder\7-Zip-Zstandard\7z.exe"


	2.	Save the Script:
	•	Ensure the script is saved with a .bat extension (e.g., compress_7zip_std.bat).

5. Usage Instructions
	1.	Place the Script in the Desired Folder:
	•	Move the script (compress_7zip_std.bat) to the folder where you want to compress files.
	•	The script will process all files in the folder and its subfolders.
	2.	Run the Script:
	•	Double-click the script to run it.
	•	Follow the on-screen instructions:
	•	Read the description and legal disclaimer.
	•	Type Y to proceed or N to exit.
	3.	Review the Log File:
	•	After the script completes, check the log file (compression_log_DATE.txt) in the same folder for a summary of actions, including:
	•	Successfully compressed files.
	•	Files that were already compressed and skipped.
	•	Errors encountered during compression or validation.

6. Notes and Recommendations
	1.	Ensure Backups:
	•	Always back up your data before running the script, especially if the files are critical.
	2.	Technical Competence:
	•	The script is intended for users familiar with file compression and automation.
	•	If unsure, seek assistance from a technically competent individual.
	3.	Test on a Small Dataset:
	•	Before using the script on a large set of files, test it on a small subset to ensure it works as expected.

7. Troubleshooting
	1.	7-Zip Path Error:
	•	If the script cannot find 7z.exe, ensure the path set in the script matches the installation folder of 7-Zip Zstandard.
	2.	Permission Issues:
	•	Run the script as an administrator if it encounters permission errors.
	3.	Corrupted Compressed Files:
	•	If a .zst file is flagged as corrupted, manually verify it and re-compress if necessary.

8. Legal Disclaimer

This script is provided “as is,” without any express or implied warranties, including but not limited to the implied warranties of merchantability, fitness for a particular purpose, or non-infringement. By using this script, you acknowledge that you assume all responsibility for its use and any outcomes. See the script’s legal disclaimer section for details.

Feel free to share this script or modify it for your specific needs, adhering to the terms outlined in the legal disclaimer. For assistance, visit the 7-Zip Zstandard GitHub page.