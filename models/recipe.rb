require_relative 'connection'

class Recipe
  attr_reader :id, :name, :instructions, :description

  def initialize(id, name, instructions, description)
    @id = id
    @name = name
    @instructions = instructions ||= "This recipe doesn't have any instructions."
    @description = description ||= "This recipe doesn't have a description."
  end

  def self.find(recipe_id)
    recipes = all
    recipes.each do |recipe|
      if recipe_id == recipe.id
        return recipe
      end
    end
  end

  def self.all
    sql = "SELECT * FROM recipes;"
    recipe_instances = []
    recipes_from_database = db_connection do |conn|
      conn.exec(sql)
    end
    recipes_from_database.each do |row|
      recipe_instances << Recipe.new(row["id"], row["name"],
                                    row["instructions"], row["description"])
    end
    recipe_instances
  end

  def ingredients
    ingredient_sql = "SELECT ingredients.id, ingredients.name
                      FROM recipes
                      JOIN ingredients
                      ON(recipes.id = ingredients.recipe_id);"
    recipe_ingredient_list = []
    ingredients_from_database = db_connection do |conn|
                                  conn.exec(ingredient_sql)
                                end
    ingredients_from_database.each do |ingredient|
      recipe_ingredient_list << Ingredient.new(ingredient["id"], ingredient["name"])
    end
    recipe_ingredient_list
  end


end
