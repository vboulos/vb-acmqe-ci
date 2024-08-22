# acm-qe-ci
This repo is the automation framework for the ACM QE team.

## Code Review and Merge Process
Please make sure you follow this process when contributing to this repo
[Code Review and Merge Process](https://docs.google.com/document/d/1Ek90owlpB1NGqBOFX0o2pUNNbSS8fisdwqMYW11G2n0/edit?usp=sharing).

## Common Tags for Test Cases
- `@e2e` - End-to-end test cases
- `@non-ui` - End-to-end Non UI test cases
- `@ocpInterop` - Test cases involving OCP interoperability
- `@post-release` - Post-release test cases to be run after every GA
- `@pre-upgrade` - Set-up of an upgrade environment
- `@post-upgrade` - Test cases related to verification after an environment has been upgraded
- `@post-restore` - Test cases involving test cases to be run after an environment has been restored


## Filter with Tags

You can select tests to run or skip using tags by passing `--env grepTags=...` value.

```
# run the tests with tag "@e2e" or "@non-ui"
--env grepTags="@e2e @non-ui"

# run the tests with both tags "@@e2e" and "@non-ui"
--env grepTags="@e2e+@non-ui"

# run the tests with "login" in the title and tag "@smoke"
--env grep=login,grepTags=@smoke

# only run the specs that have any tests tagged "@smoke"
--env grepTags=@smoke,grepFilterSpecs=true

# run only tests that do not have any tags and are not inside suites that have any tags
 --env grepUntagged=true
 

"grepFilterSpecs":  true is the option to "preview" the spec file and if it has NO tag or grep string we are looking for in the test title, completely filter out the spec file.
"grepOmitFiltered": true is the option to omit the filtered tests completely. It "hides" the tests that should not run.
```

## Owners/Maintainers
If there are any questions or concerns, reach out to the ACM QE CI Team.
- [Vincent Boulos](https://github.com/vboulos)
