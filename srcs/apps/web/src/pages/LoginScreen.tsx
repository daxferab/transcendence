function LoginScreen() {
  return (
    <div className="min-h-screen bg-emerald-700 flex items-center justify-center">
      <div className="bg-amber-300 w-80 rounded-4xl p-8 shadow-2xl">
        <h1 className="text-2xl text-emerald-700 text-center mb-6 font-extrabold">LOGIN</h1>
        <form className="space-y-4">
          <input type="text" placeholder="email" className="w-full px-3 py-2 rounded" />
          <input type="password" placeholder="password" className="w-full px-3 py-2 rounded" />
          <button type="submit" className="w-full py-2 bg-amber-100 text-amber-900 rounded-2xl">
            Log in
          </button>
          <p className="text-center">- OR -</p>
          <div className="flex gap-2">
            <button type="button" className="flex-1 bg-amber-100 text-amber-900 rounded-full aspect-square">G</button>
            <button type="button" className="flex-1 bg-amber-100 text-amber-900 rounded-full aspect-square">M</button>
            <button type="button" className="flex-1 bg-amber-100 text-amber-900 rounded-full aspect-square">A</button>
          </div>
        </form>
      </div>
    </div>
  )
}

export default LoginScreen
