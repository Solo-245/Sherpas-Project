import { getDefaultConfig } from '@rainbow-me/rainbowkit';
import {
  arbitrum,
  base,
  mainnet,
  optimism,
  polygon,
  sepolia,
  baseSepolia,
} from 'wagmi/chains';

export const config = getDefaultConfig({
  appName: 'sherpas-supply',
  projectId: '9c7d72159a8c34139d1ec23b00c65536', // for WalletConnect Integration
  chains: [
    sepolia,
    base,
    mainnet,
    baseSepolia,
  ],
  ssr: true,
});