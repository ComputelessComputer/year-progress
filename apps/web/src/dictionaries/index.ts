import "server-only";
import type { Locale } from "@/middleware";

export interface Dictionary {
  navigation: {
    home: string;
    privacy: string;
    terms: string;
  };
  home: {
    title: string;
    description: string;
    currentProgress: string;
    daysLeft: string;
  };
  features: {
    simple: string;
    simpleDescription: string;
    multipleTimeScales: string;
    multipleTimeScalesDescription: string;
    menuBarIntegration: string;
    menuBarIntegrationDescription: string;
    nativeMacOSApp: string;
    nativeMacOSAppDescription: string;
  };
  background: {
    title: string;
    description1: string;
    natFriedmanLink: string;
    description2: string;
    quote: string;
    description3: string;
    description4: string;
    whyUseThis: {
      title: string;
      description: string;
      intro: string;
      whyItMatters: string;
      benefits: {
        seeTimeDifferently: string;
        stayMotivated: string;
        minimal: string;
        betterThanExisting: string;
      };
      conclusion: string;
    };
  };
}

const dictionaries = {
  en: () => import("./en.json").then((module) => module.default),
  ko: () => import("./ko.json").then((module) => module.default),
} as const;

export const getDictionary = async (locale: Locale): Promise<Dictionary> =>
  dictionaries[locale]();
