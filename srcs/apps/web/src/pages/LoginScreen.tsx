import googleLogo from '../assets/google-logo.png'
import githubLogo from '../assets/github-logo.png'
import appleLogo from '../assets/apple-logo.png'

import { useTranslation } from 'react-i18next'

function LoginScreen() {
  const { t } = useTranslation();
  return (
    <div className="min-h-screen bg-purple-300 flex items-center justify-center">
      <div className="bg-white w-80 rounded-4xl p-8 border-3">
        <h1 className="text-2xl text-center mb-6 font-extrabold">{t("login")}</h1>
        <form className="space-y-4">
          <input type="text" placeholder="email" className="w-full px-3 py-2 rounded" />
          <input type="password" placeholder="password" className="w-full px-3 py-2 rounded" />
          <button type="submit" className="w-full py-2 bg-amber-400 border-3 border-black text-black rounded-2xl">
            Log in
          </button>
          <p className="text-center">- OR -</p>
          <div className="flex gap-6">
            <button type="button" className="flex-1 bg-white border-3 border-black text-black rounded-full aspect-square">
              <img src={googleLogo} alt="Google logo" />
            </button>
            <button type="button" className="flex-1 bg-white border-3 border-black text-black rounded-full aspect-square">
              <img src={githubLogo} alt="Github logo" />
            </button>
            <button type="button" className="flex-1 bg-white border-3 border-black text-black rounded-full aspect-square">
              <img src={appleLogo} alt="Apple logo" />
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}

export default LoginScreen
