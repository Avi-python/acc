# Issue
- [x] add new record using the acc home_widget, switch back to the app the new record will not show up

# TODO
- [x] Backup to notion
- [ ] Let user to input the NOTION API KEY and DATABASE ID (then store it in the encrypted way)
- [x] Implement Soft delete
  - But this soft delete only use for mark the transaction as delete before sync. When execute syncing, 
- [ ] Upgrade UI
- [ ] User guideline about how to setup the notion db

# Future Feature
- [ ] dump all the transacions
  - have to think about how to sync this dump action to the notion
    - link a transaction to a specific databaseId ?
- [ ] First time sync
  - when user change the device or reinstall the app (which data is empty in local but store in remote), sync the data from remote to local
- [ ] Notion edit
  - Can edit transaction on notion
  - Conflict problem
    - use lastUpdatedAt attribute to resolve the data consistency problem
    - Archive issue