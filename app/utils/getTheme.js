import { useColorScheme } from "react-native";
import Colors from "../constants/theme";

function getTheme() {
  let colorScheme = useColorScheme();
  const theme = colorScheme === "dark" ? Colors.dark : Colors.light;
  theme.currentTheme = colorScheme;
  return theme;
}

export default getTheme;
