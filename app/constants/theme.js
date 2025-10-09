import { Platform } from "react-native";

// const tintColorLight = "#0a7ea4";
// const tintColorDark = "#FEEFD9";

const Colors = {
  light: {
    text: "#11181C",
    background: "#403830ff",
    backgroundLight: "#FEEFD9",
    button: "#b09a79ff",
    buttonText: "#130C0C",

    // tint: tintColorLight,
    // icon: "#687076",
    // tabIconDefault: "#687076",
    // tabIconSelected: tintColorLight,
  },
  dark: {
    text: "#F8F1E7",
    background: "#1E1B17",
    backgroundLight: "#403830ff",
    button: "#4a3e2eff",
    buttonText: "#F8F1E7",

    // tint: tintColorDark,
    // icon: "#4B4035",
    // tabIconDefault: "#9BA1A6",
    // tabIconSelected: tintColorDark,
  },
};

export const Fonts = Platform.select({
  ios: {
    /** iOS `UIFontDescriptorSystemDesignDefault` */
    sans: "system-ui",
    /** iOS `UIFontDescriptorSystemDesignSerif` */
    serif: "ui-serif",
    /** iOS `UIFontDescriptorSystemDesignRounded` */
    rounded: "ui-rounded",
    /** iOS `UIFontDescriptorSystemDesignMonospaced` */
    mono: "ui-monospace",
  },
  default: {
    sans: "normal",
    serif: "serif",
    rounded: "normal",
    mono: "monospace",
  },
  web: {
    sans: "system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif",
    serif: "Georgia, 'Times New Roman', serif",
    rounded:
      "'SF Pro Rounded', 'Hiragino Maru Gothic ProN', Meiryo, 'MS PGothic', sans-serif",
    mono: "SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace",
  },
});

export default Colors;
