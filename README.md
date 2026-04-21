# claude-atlassian-mcp
Configure Claude (macOS) to use Atlassian mcp with credentials stored in your Keychain
1. disconnect the Atlassian connector in Claude (if previously configured)
2. install brew and npx

    `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

    `brew install node`


3. create 2 Atlassian API tokens with scopes as follows

    i. go to https://id.atlassian.com/manage-profile/security/api-tokens

    ii. click "Create API token with scopes"
   
    iii. enter a name and choose an expiry date and click Next
   
    iv. select Confluence and click Next
   
    v. add the following scopes and click Next
   
       read:page:confluence
       read:space:confluence
       read:hierarchical-content:confluence
       read:comment:confluence
       search:confluence
     vi. click "Create token"

     vii. copy the token to a safe place...you'll need this later

     viii. repeat steps ii to vii, choosing Jira and add the following scopes
   
       read:jira-work
       read:jira-user
4. using Terminal, generate a base64 encoded string for each of the 2 tokens. it will paste to the clipboard. Save these for next step. Replace `<email address>` with your Atlassian email address. Replace `<token>` with the token generated for Jira and Confluence The base64 encoded credentials will copied directly to your Clipboard.

	You can use `gen_base64.sh` in the repo. Edit the script with your email and token then run as `sh ./get_base64.sh`. Token is saved to your Clipboard.
     
      `printf '%s' "<email address>:<token>" | base64 | tr -d '\n' | pbcopy`
      
6. create 2 Keychain entries for the 2 base64 encoded strings (from step 3)

	i. open Keychain
	
	ii. File (menu) --> New Password Item...
	
	iii. enter confluence_token for "Keychain Item Name"
	
	iv. enter you Mac's username in "Account Name". Run `echo $USER` in Terminal if you're unsure
	
	v. paste the (corresponding) base64 encoded string
	
	vi. click Add
	
	vii. repeat with the jira token. Use jira_token for "Keychain Item Name"
	
7. create `~/Library/Application Support/Claude/scripts` and copy in `jira.sh` and `confluence.sh`

8. add the following json to `~/Library/Application Support/Claude/claude_desktop_config.json`. Replace `<Mac username>` with your username from step 5 iv above
```
    "mcpServers": {
        "jira": {
            "command": "sh",
            "args": [
                "/Users/<Mac username>/Library/Application Support/Claude/scripts/jira.sh"
            ]
        },
        "confluence": {
            "command": "sh",
            "args": [
                "/Users/<Mac username>/Library/Application Support/Claude/scripts/confluence.sh"
            ]
        }
    }
``` 
8. quit Claude (if not already) and open

9. when prompted, enter your Mac password. You can choose to "Always Allow" to stop the prompts each time Claude is opened

10. make sure you have memory enabled...Settings --> Capabilities --> Generate memory from chat history
