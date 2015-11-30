# include_recipe 'nginx'

template "#{node.nginx.dir}/sites-available/#{node.gowebserver.name}.conf" do
	owner "root"
	group "root"
	source "sites-available/#{node.gowebserver.name}.conf.erb"
	mode "0644"
end

nginx_site "#{node.gowebserver.name}.conf" do
	enable true
end
