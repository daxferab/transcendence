import i18n from "i18next";
import LanguageDetector from "i18next-browser-languagedetector";
import { initReactI18next } from "react-i18next";
import enTranslations from "./locales/en/translation";
import esTranslations from "./locales/es/translation";
import frTranslations from "./locales/fr/translation";

const resources = {
  ...enTranslations,
  ...esTranslations,
  ...frTranslations,
};

// Initialize i18next
i18n
  .use(LanguageDetector) // Detect user language
  .use(initReactI18next)
  .init({
    resources,
    fallbackLng: "en", // Default language if detection fails

    interpolation: {
      escapeValue: false,

      // Custom formatter for dates and currencies
      format: (value, format, lng) => {

        if (format === "date") {
          return new Intl.DateTimeFormat(lng, {
            year: "numeric",
            month: "long",
            day: "numeric",
          }).format(value);
        }

        return value;
      },
    },
  });

export default i18n;