import { useTranslation } from 'react-i18next'

function LoginScreen() {
  const { t } = useTranslation();
  return (
    <div className="min-h-screen bg-primary-200 flex items-center justify-center font-mono">
      <div className="bg-secondary w-80 rounded-4xl p-8">
        <h1 className="text-2xl text-center mb-6 font-extrabold">{t("app.name")}</h1>
        <form className="space-y-4">
          <input type="text" placeholder="email" className="w-full px-3 py-2 rounded" />
          <input type="password" placeholder="password" className="w-full px-3 py-2 rounded" />
          <button type="submit" className="w-full py-2 bg-accent-500 text-secondary font-bold rounded-2xl">
            log in
          </button>
        </form>
      </div>
    </div>
  )
}

export default LoginScreen
