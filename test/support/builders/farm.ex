defmodule SuperSeed.Support.Builders.Farm do
  @behaviour SuperSeed.Support.Builder

  alias SuperSeed.Repo
  alias SuperSeed.Support.Schemas.Farm

  def build do
    %Farm{
      name: Faker.Company.name(),
      location: Faker.Address.city(),
      acreage: Decimal.new(:rand.uniform(500) + 50),
      established_date: Faker.Date.between(~D[1950-01-01], ~D[2020-12-31]),
      owner_name: Faker.Person.name(),
      phone: Faker.Phone.EnGb.number(),
      email: Faker.Internet.email()
    }
  end

  def insert!(farm) do
    Repo.insert!(farm)
  end

  def insert!, do: insert!(build())

  def with_name(farm, name), do: %{farm | name: name}
  def with_location(farm, location), do: %{farm | location: location}
  def with_acreage(farm, acreage), do: %{farm | acreage: acreage}

  def with_established_date(farm, established_date),
    do: %{farm | established_date: established_date}

  def with_owner_name(farm, owner_name), do: %{farm | owner_name: owner_name}
  def with_phone(farm, phone), do: %{farm | phone: phone}
  def with_email(farm, email), do: %{farm | email: email}
end
