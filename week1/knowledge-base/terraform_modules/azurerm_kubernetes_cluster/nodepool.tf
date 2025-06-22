resource "azurerm_kubernetes_cluster_node_pool" "node_pool" {
  for_each                = { for each in var.pool_names : each.name => each }
  name                    = each.value.name
  host_encryption_enabled = true
  kubernetes_cluster_id   = azurerm_kubernetes_cluster.aks.id
  node_count              = each.value.enable_auto_scaling ? null : each.value.node_count
  vm_size                 = each.value.vm_size
  os_type                 = each.value.os_type
  os_sku                  = each.value.os_sku
  os_disk_size_gb         = each.value.os_disk_size_gb
  vnet_subnet_id          = data.azurerm_subnet.subnet.id
  max_pods                = each.value.max_pods
  auto_scaling_enabled    = each.value.enable_auto_scaling
  min_count               = each.value.enable_auto_scaling ? each.value.min_count : null
  max_count               = each.value.enable_auto_scaling ? each.value.max_count : null
  mode                    = each.value.pool_mode
  zones                   = each.value.agents_availability_zones
  linux_os_config {
    dynamic "sysctl_config" {
      for_each = each.value.sysctl_config[*]
      content {
        fs_aio_max_nr                     = each.value.sysctl_config.fs_aio_max_nr != null ? each.value.sysctl_config.fs_aio_max_nr : null
        fs_file_max                       = each.value.sysctl_config.fs_file_max != null ? each.value.sysctl_config.fs_file_max : null
        fs_inotify_max_user_watches       = each.value.sysctl_config.fs_inotify_max_user_watches != null ? each.value.sysctl_config.fs_inotify_max_user_watches : null
        fs_nr_open                        = each.value.sysctl_config.fs_nr_open != null ? each.value.sysctl_config.fs_nr_open : null
        kernel_threads_max                = each.value.sysctl_config.kernel_threads_max != null ? each.value.sysctl_config.kernel_threads_max : null
        net_core_netdev_max_backlog       = each.value.sysctl_config.net_core_netdev_max_backlog != null ? each.value.sysctl_config.net_core_netdev_max_backlog : null
        net_core_optmem_max               = each.value.sysctl_config.net_core_optmem_max != null ? each.value.sysctl_config.net_core_optmem_max : null
        net_core_rmem_default             = each.value.sysctl_config.net_core_rmem_default != null ? each.value.sysctl_config.net_core_rmem_default : null
        net_core_rmem_max                 = each.value.sysctl_config.net_core_rmem_max != null ? each.value.sysctl_config.net_core_rmem_max : null
        net_core_somaxconn                = each.value.sysctl_config.net_core_somaxconn != null ? each.value.sysctl_config.net_core_somaxconn : null
        net_core_wmem_default             = each.value.sysctl_config.net_core_wmem_default != null ? each.value.sysctl_config.net_core_wmem_default : null
        net_core_wmem_max                 = each.value.sysctl_config.net_core_wmem_max != null ? each.value.sysctl_config.net_core_wmem_max : null
        net_ipv4_ip_local_port_range_max  = each.value.sysctl_config.net_ipv4_ip_local_port_range_max != null ? each.value.sysctl_config.net_ipv4_ip_local_port_range_max : null
        net_ipv4_ip_local_port_range_min  = each.value.sysctl_config.net_ipv4_ip_local_port_range_min != null ? each.value.sysctl_config.net_ipv4_ip_local_port_range_min : null
        net_ipv4_neigh_default_gc_thresh1 = each.value.sysctl_config.net_ipv4_neigh_default_gc_thresh1 != null ? each.value.sysctl_config.net_ipv4_neigh_default_gc_thresh1 : null
        net_ipv4_neigh_default_gc_thresh2 = each.value.sysctl_config.net_ipv4_neigh_default_gc_thresh2 != null ? each.value.sysctl_config.net_ipv4_neigh_default_gc_thresh2 : null
        net_ipv4_neigh_default_gc_thresh3 = each.value.sysctl_config.net_ipv4_neigh_default_gc_thresh3 != null ? each.value.sysctl_config.net_ipv4_neigh_default_gc_thresh3 : null
        net_ipv4_tcp_fin_timeout          = each.value.sysctl_config.net_ipv4_tcp_fin_timeout != null ? each.value.sysctl_config.net_ipv4_tcp_fin_timeout : null
        net_ipv4_tcp_keepalive_intvl      = each.value.sysctl_config.net_ipv4_tcp_keepalive_intvl != null ? each.value.sysctl_config.net_ipv4_tcp_keepalive_intvl : null
        net_ipv4_tcp_keepalive_probes     = each.value.sysctl_config.net_ipv4_tcp_keepalive_probes != null ? each.value.sysctl_config.net_ipv4_tcp_keepalive_probes : null
        net_ipv4_tcp_keepalive_time       = each.value.sysctl_config.net_ipv4_tcp_keepalive_time != null ? each.value.sysctl_config.net_ipv4_tcp_keepalive_time : null
        net_ipv4_tcp_max_syn_backlog      = each.value.sysctl_config.net_ipv4_tcp_max_syn_backlog != null ? each.value.sysctl_config.net_ipv4_tcp_max_syn_backlog : null
        net_ipv4_tcp_max_tw_buckets       = each.value.sysctl_config.net_ipv4_tcp_max_tw_buckets != null ? each.value.sysctl_config.net_ipv4_tcp_max_tw_buckets : null
        vm_max_map_count                  = each.value.sysctl_config.vm_max_map_count != null ? each.value.sysctl_config.vm_max_map_count : null
        vm_swappiness                     = each.value.sysctl_config.vm_swappiness != null ? each.value.sysctl_config.vm_swappiness : null
        vm_vfs_cache_pressure             = each.value.sysctl_config.vm_vfs_cache_pressure != null ? each.value.sysctl_config.vm_vfs_cache_pressure : null
      }

    }
  }
  lifecycle {
    ignore_changes = [tags]
  }

}
