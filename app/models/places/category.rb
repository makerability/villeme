class Category < ActiveRecord::Base

	# Globalize
	translates :name

	# Urls bonitas
  extend FriendlyId
  friendly_id :name, use: :slugged

	# associações
	has_and_belongs_to_many :items
	has_and_belongs_to_many :places

	def self.get_names(categories)
		categories.pluck(:name)
	end

	def self.to_query(categories, options = {key: true})
		if categories.is_a? Array
			response = options[:key] ? "category=#{categories.join('+')}" : categories.join('+')
		elsif categories.is_a? ActiveRecord::Relation
			options[:key] ? "category=#{categories.pluck(:name).join('+')}" : categories.pluck(:name).join('+')
		else
			nil
		end
	end

	def self.query_to_array(categories_query)
		categories_query ? categories_query.split('+') : []
	end


end
