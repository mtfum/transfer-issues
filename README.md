# GitHub Issues Transfer Tool

A simple bash script to transfer GitHub issues from one repository to another using the GitHub CLI (`gh`).

## Features

- Transfer all open issues from a source repository to a destination repository
- Excludes pull requests automatically
- Progress tracking with detailed console output
- Success and failure logging
- Rate limiting protection with automatic delays

## Prerequisites

- [GitHub CLI (`gh`)](https://cli.github.com/) installed and authenticated
- Bash shell
- Write access to both source and destination repositories

## Installation

1. Clone this repository:
```bash
git clone git@github.com:mtfum/transfer-issues.git
cd transfer-issues
```

2. Make the script executable:
```bash
chmod +x transfer-with-gh.sh
```

3. Set up your environment variables:
```bash
cp .env.sample .env
```

4. Edit `.env` and configure your repositories:
```bash
SOURCE_REPO=owner/source-repo
DEST_REPO=owner/destination-repo
```

## Usage

Run the transfer script:

```bash
./transfer-with-gh.sh
```

The script will:
1. Fetch all open issues from the source repository
2. Transfer them one by one to the destination repository
3. Display progress in the console
4. Save logs to `./gh-transfer-logs/`

### Log Files

After execution, you'll find the following logs in `./gh-transfer-logs/`:

- `success.log` - Raw output from successful transfers
- `transferred.txt` - List of transferred issues (format: `number|title`)
- `failed.txt` - List of failed transfers (format: `number|title`)

## Example Output

```
Fetching open issues from owner/source-repo...
Found 10 open issues to transfer
[1/10] Transferring #42: Fix authentication bug
  ✓ Success
[2/10] Transferring #43: Add dark mode support
  ✓ Success
...
Transfer complete!
Success: 10
Failed: 0
Logs saved in: ./gh-transfer-logs
```

## Notes

- **One-way transfer**: Issues are moved from source to destination. The original issues will be closed and redirected.
- **Preserve history**: GitHub maintains a redirect link from the original issue to the transferred one.
- **Rate limiting**: The script includes a 0.5-second delay between transfers to avoid rate limits.
- **Pull requests**: Pull requests are automatically excluded from the transfer.

## Troubleshooting

### Authentication Error

Make sure you're authenticated with the GitHub CLI:
```bash
gh auth login
```

### Permission Denied

Ensure you have write access to both repositories. You may need to request access from the repository owner.

### No Issues Found

Verify that:
- The repository paths are correct in your `.env` file
- There are open issues in the source repository
- You have read access to the source repository

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

Created for efficient GitHub issue management and repository migrations.
