# encoding: utf-8

module ApplicationHelper


	def flash_message
		messages = ""
		[:notice, :info, :warning, :error].each {|type|
			if flash[type]
				messages += "<div class=\"alert alert-#{type} alert-dismissible\" role=\"alert\">
											<button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button>
											#{flash[type]}
										</div>"
			end
		}

		messages.html_safe
	end


	@gamification_active = false



	def javascript_load_dependencies(files_array = [], options = {sync: true})
		response = ""

		if files_array.is_a? Array
			files_array.each { |file_name| response += javascript_include_tag(file_name, sync: options[:sync]) }
		else
			response += javascript_include_tag(files_array, sync: options[:sync])
		end

		if self.request.wiselinks?
			response.html_safe
		else
			content_for(:javascript_load_dependencies) { response.html_safe }
		end
	end

	def javascript_load_inline(files = [])
		content_for(:javascript_load_inline) do
			files.each do |name_of_file|
				"<script type='text/javascript'>#{Rails.application.assets.find_asset("#{name_of_file}.js").to_s}</script>".html_safe
			end
		end
	rescue
		nil
	end

	def javascript_load_content(files_array = [], options = {sync: false})
		response = ""

		if files_array.is_a? Array
			files_array.each { |file_name| response += javascript_include_tag(file_name, sync: options[:sync]) }
		else
			response += javascript_include_tag(files_array, sync: options[:sync])
		end

		if self.request.wiselinks?
			response.html_safe
		else
			content_for(:javascript_load_content) do
				response.html_safe
			end
		end

	end

	def mount_riot_components(content = nil, &block)
		content = block_given? ? capture(&block) : content

		if self.request.wiselinks?
			content
		else
			content_for(:mount_riot_components, content)
		end
	end

	def stylesheet_inline(name_of_file)
		"<style type='text/css'>#{Rails.application.assets.find_asset("#{name_of_file}.css").to_s}</style>".html_safe
	end

	def css(*files)
	  content_for(:css) { stylesheet_link_tag(*files) }
	end	




  # TODO: Remove this -> duplicated
	def get_avatar(user, w = "38", h = "38")

		size = "#{w}x#{h}"

		if user.is_a? Numeric
			user = User.find user
		end

		if user_signed_in?
			if user.avatar_file_name != nil
				return image_tag user.avatar.url(:thumb), class: 'avatar-upload img-circle image', size: size, alt: user.name
			elsif user.facebook_avatar
				return image_tag "#{user.facebook_avatar}&width=#{w}&height=#{h}", class: 'avatar-upload img-circle image', size: size, alt: user.name
			else
				return image_tag 'thumb/missing.png', class: 'avatar-upload img-circle image', size: size
			end
		else
			return image_tag 'thumb/missing.png', class: 'avatar-upload img-circle image', size: size
		end
	end









	# Botao para ações de amizade
	# -> Adicionar e destruir amizade 

	DEFAULT = {status: "auto", hash: false, css: nil}

	def btn_friend(user, friend, options = {})
		
		options = DEFAULT.merge(options)

		# Blocos de 'status'

		confirmed = proc do
			if hash
				btn = "<button id='friend-btn-#{friend[:id]}' class='btn btn-default friend-destroy has-hover-action #{options[:css]}' data-text-default='Amigo' data-text-hover='Desfazer amizade' data-class-hover='btn-danger btn-default' data-friend-object='#{friend[:slug]}'>Amigo</button>".html_safe		
			else	
				btn = "<button id='friend-btn-#{friend.id}' class='btn btn-default friend-destroy has-hover-action #{options[:css]}' data-text-default='Amigo' data-text-hover='Desfazer amizade' data-class-hover='btn-danger btn-default' data-friend-object='#{friend.slug}'>Amigo</button>".html_safe
			end
		end
		

		requested = proc do
			if hash
				btn = "<button id='friend-btn-#{friend[:id]}' class='btn btn-default friend-destroy #{options[:css]}' data-friend-object='#{friend[:slug]}'>Amizade solicitada</button>".html_safe			
			else	
				btn = "<button id='friend-btn-#{friend.id}' class='btn btn-default friend-destroy #{options[:css]}' data-friend-object='#{friend.slug}'>Amizade solicitada</button>".html_safe
			end
		end


		pending = proc do
			if options[:hash]
				btn = "<button id='friend-btn-#{friend[:id]}' class='btn btn-success friend-accept #{options[:css]}' data-friend-object='#{friend[:slug]}'>Aceitar amizade</button>".html_safe		
			else	
				btn = "<button id='friend-btn-#{friend.id}' class='btn btn-success friend-accept #{options[:css]}' data-friend-object='#{friend.slug}'>Aceitar amizade</button>".html_safe
			end
		end


		not_friend = proc do
			if options[:hash]
				btn = "<button id='friend-btn-#{friend[:id]}' class='btn btn-success friend-request #{options[:css]}' data-friend-object='#{friend[:slug]}'>Solicitar amizade</button>".html_safe			
			else	
				btn = "<button id='friend-btn-#{friend.id}' class='btn btn-success friend-request #{options[:css]}' data-friend-object='#{friend.slug}'>Solicitar amizade</button>".html_safe
			end
		end	

		
		# Algoritimo

		case options[:status]
		when "confirmed"
			confirmed.call
		
		when "requested"
			requested.call

		when "pending"
			pending.call

		when "not-friend"
			not_friend.call

		when "auto"
			if current_user.are_friends? friend
				confirmed.call
			else
				not_friend.call							
			end
		end

	end





end
