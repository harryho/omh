# SOURCE INVENTORY — LedgerLite

*Fictional worked example for the omh harness. LedgerLite does not exist; every document in
`examples/ledgerlite/` demonstrates the templates on it.*

| | |
|---|---|
| **Contract kind** | legacy-app |
| **Source** | LedgerLite 1.4 (WPF .NET 4.8, single-user desktop) |

## Capabilities

| id | capability | source ref | disposition | reason |
|---|---|---|---|---|
| LLD-1 | double-entry ledger core | `Ledger.Core/LedgerBook.cs` | port | the product's spine |
| LLD-2 | manual expense entry | `Views/EntryView.xaml` | port | core input path |
| LLD-3 | income entry | `Views/EntryView.xaml` | port | core input path |
| LLD-4 | category tree (2 levels) | `Ledger.Core/Category.cs` | port | budgeting depends on it |
| LLD-5 | recurring entries (monthly) | `Ledger.Core/RecurringRule.cs` | port | high-use per support history |
| LLD-6 | per-category monthly budget | `Views/BudgetView.xaml` | port | core planning feature |
| LLD-7 | bank CSV (OFX) import | `Ledger.IO/OfxReader.cs` | port | data entry volume driver |
| LLD-8 | month summary report | `Views/ReportView.xaml` | port | most-used report |
| LLD-9 | category pie chart | `Views/ReportView.xaml` | port | chart library swaps WPF→web; capability persists |
| LLD-10 | search + filter entries | `Views/SearchView.xaml` | port | daily use |
| LLD-11 | backup/restore to file | `Ledger.IO/Backup.cs` | port | data safety |
| LLD-12 | data migration wizard (1.0→1.4) | `Views/MigrateView.xaml` | port | existing files must load |
| LLD-13 | CSV export | `Ledger.IO/CsvWriter.cs` | port | interop |
| LLD-14 | web dashboard | — | NEW | web-native landing summary; no old equivalent |
| LLD-15 | shareable report links | — | NEW | web-native; requested by pilot users |
| LLD-16 | cheque register print | `Views/ChequeView.xaml` | drop | no cheque usage in target market |
| LLD-17 | tray minimize + global hotkey | `App.xaml.cs` | drop | desktop-only concepts; no web equivalent |
| LLD-18 | audit log of entry edits | `Ledger.Core/AuditTrail.cs` | drop | single-user; cost > value |
| LLD-19 | multi-currency accounts | — | defer | single currency in v1; revisit post-launch |
| LLD-20 | OFX auto-sync scheduling | — | defer | import suffices for v1; scheduler is server work |

## Counts

`20 total — port 13 · NEW 2 · drop 3 · defer 2`
