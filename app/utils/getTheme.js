import { useColorScheme } from "react-native";
import Colors from "../constants/theme";

function getTheme() {
  let colorScheme = useColorScheme();
  const theme = colorScheme === "light" ? Colors.light : Colors.dark;
  theme.currentTheme = colorScheme || "dark"; // defaults to dark
  return theme;
}

export default getTheme;
