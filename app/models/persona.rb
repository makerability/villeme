class Persona < ActiveRecord::Base

	# Globalize
	translates :name

	# associações
	has_and_belongs_to_many :users
	has_and_belongs_to_many :items
	has_and_belongs_to_many :invites

	def self.get_names(personas)
		personas.pluck(:name)
	end

	def self.to_query(personas)
		"persona=#{personas.pluck(:name).join('+')}"
	end


end
