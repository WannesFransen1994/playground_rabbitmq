{application,rabbit_chat,
             [{applications,[kernel,stdlib,elixir,logger,runtime_tools,
                             phoenix,phoenix_html,phoenix_live_reload,
                             phoenix_live_view,phoenix_live_dashboard,esbuild,
                             swoosh,telemetry_metrics,telemetry_poller,
                             gettext,jason,plug_cowboy,amqp]},
              {description,"rabbit_chat"},
              {modules,['Elixir.RabbitChat','Elixir.RabbitChat.Application',
                        'Elixir.RabbitChat.ChatContext',
                        'Elixir.RabbitChat.ChatContext.Chatter',
                        'Elixir.RabbitChat.ChatContext.ChattersInMemDB',
                        'Elixir.RabbitChat.ChatContext.Message',
                        'Elixir.RabbitChat.Mailer',
                        'Elixir.RabbitChat.OTP.DynamicConsumerManager',
                        'Elixir.RabbitChat.OTP.MessagePublisher',
                        'Elixir.RabbitChat.OTP.PrivateConsumer',
                        'Elixir.RabbitChatWeb',
                        'Elixir.RabbitChatWeb.ChatterLive.Chat',
                        'Elixir.RabbitChatWeb.Endpoint',
                        'Elixir.RabbitChatWeb.ErrorHelpers',
                        'Elixir.RabbitChatWeb.ErrorView',
                        'Elixir.RabbitChatWeb.Gettext',
                        'Elixir.RabbitChatWeb.LayoutView',
                        'Elixir.RabbitChatWeb.LiveHelpers',
                        'Elixir.RabbitChatWeb.ModalComponent',
                        'Elixir.RabbitChatWeb.PageController',
                        'Elixir.RabbitChatWeb.PageView',
                        'Elixir.RabbitChatWeb.Router',
                        'Elixir.RabbitChatWeb.Router.Helpers',
                        'Elixir.RabbitChatWeb.Telemetry']},
              {registered,[]},
              {vsn,"0.1.0"},
              {mod,{'Elixir.RabbitChat.Application',[]}}]}.