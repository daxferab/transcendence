import googleLogo from '../assets/google-logo.png'
import githubLogo from '../assets/github-logo.png'
import appleLogo from '../assets/apple-logo.png'

function LoginScreen() {
  return (
    <div className="min-h-screen bg-white flex items-center justify-center">
      <div className="bg-purple-300 w-80 rounded-4xl p-8 border-2">
        <h1 className="text-2xl text-center mb-6 font-extrabold">LOGIN</h1>
        <form className="space-y-4">
          <input type="text" placeholder="email" className="w-full px-3 py-2 rounded" />
          <input type="password" placeholder="password" className="w-full px-3 py-2 rounded" />
          <button type="submit" className="w-full py-2 bg-amber-400 border-2 border-black text-black rounded-2xl">
            Log in
          </button>
          <p className="text-center">- OR -</p>
          <div className="flex gap-6">
            <button type="button" className="flex-1 bg-white border-2 border-black text-black rounded-full aspect-square">
              <img src={googleLogo} alt="Google logo" />
            </button>
            <button type="button" className="flex-1 bg-white border-2 border-black text-black rounded-full aspect-square">
              <img src={githubLogo} alt="Github logo" />
            </button>
            <button type="button" className="flex-1 bg-white border-2 border-black text-black rounded-full aspect-square">
              <img src={appleLogo} alt="Apple logo" />
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}

export default LoginScreen
