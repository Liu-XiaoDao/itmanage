class SitesController < ApplicationController
	layout 'home'

	def show

		@siteinfo = Siteinfo.first.blank? ?  Siteinfo.new : Siteinfo.first

	end

	def update
		@siteinfo = Siteinfo.first
		@siteinfo.title = params[:siteinfo][:title]
		@siteinfo.emailrecive = params[:siteinfo][:emailrecive]

		if @siteinfo.save
			redirect_to site_path
		else
			render :show
		end
	end

	def create
		@siteinfo = Siteinfo.new
		@siteinfo.title = params[:siteinfo][:title]
		@siteinfo.emailrecive = params[:siteinfo][:emailrecive]

		if @siteinfo.save
			redirect_to site_path
		else
			render :show
		end
	end

end
