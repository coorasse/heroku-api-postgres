# Models list and description

## Database

```ruby
{   :addon_id=>"database_id",
    :name=>"postgresql-horizontal-25349",
    :info=>[ { :name=>"Plan", :values=>["Hobby-basic"] },
             { :name=>"Status", :values=>["Available"] },
             { :name=>"Connections", :values=>["3/20"] },
             { :name=>"PG Version", :values=>["9.5.5"] },
             { :name=>"Created", :values=>["2016-11-12 09:59 UTC"]  },
             { :name=>"Data Size", :values=>["915.2 MB"]  },
             { :name=>"Tables", :values=>[140]  },
             { :name=>"Rows", :values=>["1788360/10000000 (In compliance)"]  },
             { :name=>"Fork/Follow", :values=>["Unsupported"]},
             { :name=>"Rollback", :values=>["Unsupported"]},
             { :name=>"Continuous Protection", :values=>["Off"]},
             { :name=>"Region", :values=>["Europe"]}
           ],
    :plan=>"Hobby-basic",
    :created_at=>"2016-11-12T09:59:55.349+00:00",
    :database_user=>"username",
    :database_name=>"schema_name",
    :available_for_ingress=>true,
    :standalone?=>false,
    :resource_url=>"postgres://username:password@url:5432/schema_name",
    :waiting?=>false,
    :num_bytes=>959652012 }
```

## Backup

```ruby
{   :uuid=>"backup_id",
    :num=>1,
    :from_name=>"DATABASE",
    :from_type=>"pg_dump",
    :from_url=>"from_url",
    :to_name=>"BACKUP",
    :to_type=>"gof3r",
    :to_url=>"to_url",
    :options=>{},
    :source_bytes=>9134252,
    :processed_bytes=>50850,
    :succeeded=>true,
    :warnings=>0,
    :created_at=>"2016-10-21 10:15:36 +0000",
    :started_at=>"2016-10-21 10:15:36 +0000",
    :canceled_at=>nil,
    :updated_at=>"2016-10-21 10:16:08 +0000",
    :finished_at=>"2016-10-21 10:16:05 +0000",
    :deleted_at=>nil,
    :purged_at=>nil,
    :num_keep=>2 }
```

## Schedule

```ruby
{   :uuid=>"schedule_id",
    :name=>"DATABASE_URL",
    :hour=>2,
    :days=>["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
    :timezone=>"Europe/Zurich",
    :created_at=>"2018-01-09 11:28:57 +0000",
    :updated_at=>"2018-03-02 01:19:52 +0000",
    :deleted_at=>nil,
    :retain_weeks=>1,
    :retain_months=>0 }
```

## BackupUrl

```ruby
{   :expires_at => "2018-03-05 22:05:36 +0000",
    :url => "https://bucket_name.s3.amazonaws.com/resource_address"
}
```
