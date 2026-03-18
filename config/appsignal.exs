import Config

{revision, _exitcode} = System.cmd("git", ["log", "--pretty=format:%h", "-n 1"])
config :appsignal, :config,
  otp_app: :social,
  revision: revision,
  name: "social",
  env: Mix.env

