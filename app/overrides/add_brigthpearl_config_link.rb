Deface::Override.new(virtual_path: 'spree/admin/shared/_configuration_menu',
                     name: 'add_brightpearl_config_link',
                     insert_bottom: '.sidebar',
                     text: '<%= configurations_sidebar_menu_item Spree.t(:brightpearl_config), edit_admin_brightpearl_path %>'
                    )
