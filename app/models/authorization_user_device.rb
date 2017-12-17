class AuthorizationUserDevice < ApplicationRecord
	belongs_to :user, optional: true
	belongs_to :authorization, optional: true
	belongs_to :device, optional: true
end
