module OmniauthHelper
  def provider_link(resource_name, provider)
    normalized_provider = (provider == :google_oauth2 ? :google : provider)
    provider_title = provider == :google_oauth2 ? "Google" : ::OmniAuth::Utils.camelize(provider)
    provider_text = "Continue with #{provider_title}"

    link_to omniauth_authorize_path(resource_name, provider), class: "px-4 py-2 inline-flex items-center text-base font-semibold text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200 focus:ring-purple-500 focus:ring-offset-purple-200 transition ease-in duration-150 focus:outline-none focus:ring-2 focus:ring-offset-2 cursor-pointer" do
      yield(normalized_provider, provider_text.html_safe)
    end.html_safe
  end
end
