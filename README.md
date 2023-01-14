# README

Generating the account first so that the references don't happen before
```bash
rails g model account name
rails g model user name email account:references
```

This gives us a user migration that looks like this:

```rb
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.references :account, null: true, foreign_key: true

      t.timestamps
    end
  end
end

```

And an account migration that looks like this:

```rb
class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name

      t.timestamps
    end
  end
end
```

Then you'll want to edit the account.rb file to look like this:

```rb
class Account < ApplicationRecord
    has_many :users
end
```

And the user.rb file:

```rb
class User < ApplicationRecord
  belongs_to :account, optional: true
end
```

```rb
a = Account.create(name: "google")
u = User.create(name: "dean", email: "dean@example.com", account: Account.first)
```

And now we can try

```rb
u
 =>
#<User:0x00007f92ade5c828
 id: 1,
 name: "dean",
 email: "dean@example.com",
 account_id: 1,
 created_at: Sat, 14 Jan 2023 04:43:32.239520000 UTC +00:00,
 updated_at: Sat, 14 Jan 2023 04:43:32.239520000 UTC +00:00>
 ```

 ```rb
a
 =>
#<Account:0x00007f92ab986be8
 id: 1,
 name: "google",
 created_at: Sat, 14 Jan 2023 04:42:57.460479000 UTC +00:00,
 updated_at: Sat, 14 Jan 2023 04:42:57.460479000 UTC +00:00>
```

```rb
u.account
 =>
#<Account:0x00007f92aaf5f660
 id: 1,
 name: "google",
 created_at: Sat, 14 Jan 2023 04:42:57.460479000 UTC +00:00,
 updated_at: Sat, 14 Jan 2023 04:42:57.460479000 UTC +00:00>
 ```

 ```rb
  a.users
  User Load (0.3ms)  SELECT "users".* FROM "users" WHERE "users"."account_id" = $1  [["account_id", 1]]
 =>
[#<User:0x00007f96dee96e58
  id: 1,
  name: "dean",
  email: "dean@example.com",
  account_id: 1,
  created_at: Sat, 14 Jan 2023 04:43:32.239520000 UTC +00:00,
  updated_at: Sat, 14 Jan 2023 04:43:32.239520000 UTC +00:00>]
  ```