alias Converge.{User, Util}

defmodule RolePlay do
	import Util, only: [path_expand_content: 1]

	def role(_tags \\ []) do
		%{
			ferm_input_chain:
				"""
				interface ($ethernet_interfaces $wifi_interfaces wg0) {
					# Steam in-home streaming
					#proto udp dport (27031 27036) ACCEPT;
					#proto tcp dport (27036 27037) ACCEPT;
				}
				""",
			ferm_output_chain:
				"""
				outerface lo {
					# Some IPC thing required for Steam games to not hang on startup
					# https://github.com/ValveSoftware/steam-for-linux/issues/4264#issuecomment-299654724
					daddr 127.0.0.1 proto tcp syn dport 57343 {
						mod owner uid-owner play ACCEPT;
					}
				}
				""",
			regular_users: [
				%User{
					name:  "play",
					home:  "/home/play",
					shell: "/bin/zsh",
					authorized_keys: [
						path_expand_content("~/.ssh/id_rsa.pub") |> String.trim_trailing
					]
				}
			],
		}
	end
end
