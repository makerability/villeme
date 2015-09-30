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

	def self.to_query(categories)
		"category=#{categories.pluck(:name).join('+')}"
	end

	def self.query_to_array(categories_query)
		categories_query.split('+')
	end


end
