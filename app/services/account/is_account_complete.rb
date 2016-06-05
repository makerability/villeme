module AccountService

  require_relative '../../domain/policies/geocoder/entity_geocoded'

  extend self

  def is_account_complete?(account)
    if complete?(account) && geocoded?(account)
      true
    else
      false
    end
  end

  private

  def complete?(account)
    account.name && account.username && account.email && account.personas.size > 0
  end

  def geocoded?(account)
    Villeme::Policies::EntityGeocoded.is_geocoded?(account)
  end


end