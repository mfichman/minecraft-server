namespace :wireguard do
  task up: :environment do
    network = Wireguard::Network.find_or_create_by!(host: Figaro.env.server_name!)
    conf = Wireguard::NetworksController.render('show', formats: [:conf], assigns: { network: network })
    Wireguard::Utils.syncconf(conf)
  end
end
