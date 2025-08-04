defmodule SuperSeed.Support.Builders.FeedType do
  @behaviour SuperSeed.Support.Builder

  alias SuperSeed.Repo
  alias SuperSeed.Support.Schemas.FeedType

  @impl true
  def build do
    %FeedType{
      name: Faker.Commerce.product_name(),
      brand: Faker.Company.name(),
      feed_category: Enum.random(["grain", "hay", "pellet", "supplement", "mineral"]),
      protein_percentage: Decimal.new(:rand.uniform(30) + 5),
      fat_percentage: Decimal.new(:rand.uniform(15) + 2),
      fiber_percentage: Decimal.new(:rand.uniform(40) + 10),
      calories_per_kg: :rand.uniform(2000) + 1500,
      cost_per_kg: Decimal.new(:rand.uniform(50) + 10),
      supplier: Faker.Company.name(),
      description: Faker.Lorem.sentence()
    }
  end

  @impl true
  def insert!(feed_type) do
    Repo.insert!(feed_type)
  end

  @impl true
  def insert!, do: insert!(build())

  def with_name(feed_type, name), do: %{feed_type | name: name}
  def with_brand(feed_type, brand), do: %{feed_type | brand: brand}
  def with_feed_category(feed_type, category), do: %{feed_type | feed_category: category}
  def with_protein_percentage(feed_type, protein), do: %{feed_type | protein_percentage: protein}
  def with_fat_percentage(feed_type, fat), do: %{feed_type | fat_percentage: fat}
  def with_fiber_percentage(feed_type, fiber), do: %{feed_type | fiber_percentage: fiber}
  def with_calories_per_kg(feed_type, calories), do: %{feed_type | calories_per_kg: calories}
  def with_cost_per_kg(feed_type, cost), do: %{feed_type | cost_per_kg: cost}
  def with_supplier(feed_type, supplier), do: %{feed_type | supplier: supplier}
  def with_description(feed_type, description), do: %{feed_type | description: description}
end
