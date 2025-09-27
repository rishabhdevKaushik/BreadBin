import { createContext, useContext, useEffect, useState } from "react";
import inputTypes from "../constants/inputType";
import { getValue } from "./storage";

// Input Amount
const InputContext = createContext();

export function InputProvider({ children }) {
  const [inputAmount, setInputAmount] = useState("");

  return (
    <InputContext.Provider value={{ inputAmount, setInputAmount }}>
      {children}
    </InputContext.Provider>
  );
}

export function useInput() {
  return useContext(InputContext);
}

// Total Amount
const TotalContext = createContext();

export function TotalProvider({ children }) {
  const [totalAmount, setTotalAmount] = useState();

  useEffect(() => {
    async function fetchTotal() {
      const total = await getValue("total");
      setTotalAmount(total || "0");
    }
    fetchTotal();
  }, []);

  return (
    <TotalContext.Provider value={{ totalAmount, setTotalAmount }}>
      {children}
    </TotalContext.Provider>
  );
}

export function useTotal() {
  return useContext(TotalContext);
}

// Input Type
const InputTypeContext = createContext();

export function InputTypeProvider({ children }) {
  // console.log(inputTypes)
  const defaultInputType = inputTypes[0];
  const [inputType, setInputType] = useState(defaultInputType);

  return (
    <InputTypeContext.Provider value={{ inputType, setInputType }}>
      {children}
    </InputTypeContext.Provider>
  );
}

export function useInputType() {
  return useContext(InputTypeContext);
}
