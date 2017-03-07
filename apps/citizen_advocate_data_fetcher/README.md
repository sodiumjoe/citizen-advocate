# CitizenAdvocateDataFetcher

Data fetching application to supply bill/committee/member data for citizen-advocate

```bash
$ iex -S mix
Erlang/OTP 19 [erts-8.2] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Interactive Elixir (1.4.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> CitizenAdvocateDataFetcher.GPO.Server.fetch_gpo_bill_data
[%{actions: [%{action_code: "", action_date: "2017-01-04",
      committee: %{name: "Highways and Transit Subcommittee",
        system_code: "hspw12"},
      text: "Referred to the Subcommittee on Highways and Transit."},
    %{action_code: "H11100", action_date: "2017-01-03",
      committee: %{name: "Transportation and Infrastructure Committee",
        system_code: "hspw00"},
      text: "Referred to the House Committee on Transportation and Infrastructure."},
    %{action_code: "Intro-H", action_date: "2017-01-03",
      committee: %{name: "", system_code: ""}, text: "Introduced in House"},
    %{action_code: "1000", action_date: "2017-01-03",
      committee: %{name: "", system_code: ""}, text: "Introduced in House"}],
   bill_number: "100", bill_type: "HR", congress: "115",
   policy_area: "Transportation and Public Works",
   subjects: %{legislative_subjects: [%{name: "Roads and highways"},
      %{name: "Transportation programs funding"},
      %{name: "Urban and suburban affairs and development"}]},
   title: "Support Local Transportation Act",
   update_date: "2017-02-15T10:26:51Z"},
	...
 %{actions: [%{action_code: "", action_date: "2017-01-19", committee: %{...},
      ...}, %{action_code: "H11100", action_date: "2017-01-03", ...},
    %{action_code: "Intro-H", ...}, %{action_code: "1000", ...}],
   bill_number: "104", bill_type: "HR", congress: "115",
   policy_area: "Armed Forces and National Security", ...},
 %{actions: [%{action_code: "H11100", action_date: "2017-02-14", ...},
    %{action_code: "H11100-A", ...}, %{...}, ...], bill_number: "1040",
   bill_type: "HR", congress: "115", ...},
 %{actions: [%{action_code: "H11100", ...}, %{...}, ...], bill_number: "1041",
   bill_type: "HR", ...}, %{actions: [%{...}, ...], bill_number: "1042", ...},
 %{actions: [...], ...}, %{...}, ...]
iex(2)> CitizenAdvocateDataFetcher.Propublica.Server.fetch_member_data
[[%{"api_uri" => "https://api.propublica.org/congress/v1/members/A000055.json",
    "district" => "4", "domain" => "aderholt.house.gov", "dw_nominate" => "",
    "facebook_account" => "RobertAderholt", "facebook_id" => "19787529402",
    "first_name" => "Robert", "google_entity_id" => "/m/024p03",
    "id" => "A000055", "ideal_point" => "", "last_name" => "Aderholt",
    "middle_name" => "B.", "missed_votes" => "0", "missed_votes_pct" => "0.00",
    "next_election" => "2018", "party" => "R",
    "rss_url" => "https://aderholt.house.gov/rss.xml", "seniority" => "22",
    "state" => "AL", "total_present" => "0", "total_votes" => "126",
    "twitter_account" => "Robert_Aderholt",
    "url" => "https://aderholt.house.gov", "votes_with_party_pct" => "96.83"},
	...
  %{"api_uri" => "https://api.propublica.org/congress/v1/members/I000024.json",
    ...}, %{...}, ...]]
iex(3)> CitizenAdvocateDataFetcher.Propublica.Server.fetch_committee_data
[[%{"api_uri" => "https://api.propublica.org/congress/v1/115/house/committees/HSHA.json",
    "chair" => "Gregg Harper", "chair_id" => "H001045", "chair_party" => "R",
    "chair_state" => "MS",
    "chair_uri" => "https://api.propublica.org/congress/v1/members/H001045.json",
    "democratic_rss" => "", "id" => "HSHA",
    "name" => "Committee on Administration", "ranking_member_id" => "B001227",
    "republican_rss" => "", "url" => "https://cha.house.gov/"},
	...
  %{"api_uri" => "https://api.propublica.org/congress/v1/115/senate/committees/SPAG.json",
    "chair" => "Susan Collins", "chair_id" => "C001035", "chair_party" => "R",
    "chair_state" => "ME",
    "chair_uri" => "https://api.propublica.org/congress/v1/members/C001035.json",
    "democratic_rss" => "", "id" => "SPAG",
    "name" => "Special Committee on Aging", "ranking_member_id" => "M001170",
    "republican_rss" => "", "url" => "http://www.aging.senate.gov/"}]]
iex(4)>
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `citizen_advocate_data_fetcher` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:citizen_advocate_data_fetcher, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/action_data_fetcher](https://hexdocs.pm/citizen_advocate_data_fetcher).

