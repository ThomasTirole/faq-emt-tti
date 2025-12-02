# Nuxt Minimal Starter

Look at the [Nuxt documentation](https://nuxt.com/docs/getting-started/introduction) to learn more.

## Setup

Make sure to install dependencies:

```bash
# npm
npm install

# pnpm
pnpm install

# yarn
yarn install

# bun
bun install
```

## Development Server

Start the development server on `http://localhost:3000`:

```bash
# npm
npm run dev

# pnpm
pnpm dev

# yarn
yarn dev

# bun
bun run dev
```

## Production

Build the application for production:

```bash
# npm
npm run build

# pnpm
pnpm build

# yarn
yarn build

# bun
bun run build
```

Locally preview production build:

```bash
# npm
npm run preview

# pnpm
pnpm preview

# yarn
yarn preview

# bun
bun run preview
```

Check out the [deployment documentation](https://nuxt.com/docs/getting-started/deployment) for more information.

## GitHub Pages Deployment

This project includes a GitHub Action that automatically builds and deploys to GitHub Pages on every push to the `main` branch.

### Setup Required Secrets

Before the deployment can work, you need to configure the following secrets in your GitHub repository:

1. Go to your repository on GitHub
2. Navigate to **Settings** > **Secrets and variables** > **Actions**
3. Click **New repository secret** and add:
   - `SUPABASE_URL`: Your Supabase project URL (e.g., `https://your-project.supabase.co`)
   - `SUPABASE_KEY`: Your Supabase **anonymous/public** key (anon key) - **never** use the service role key
   - `NUXT_PUBLIC_SITE_URL`: Your production site URL (e.g., `https://your-app.github.io/your-repo`) - This is required for email confirmation links to work correctly

> **Note**: The anonymous key is safe to use in client-side applications as it only allows operations permitted by your Row Level Security (RLS) policies. You can find these values in your Supabase project under **Settings** > **API**.

### Enable GitHub Pages

1. Go to your repository on GitHub
2. Navigate to **Settings** > **Pages**
3. Under **Build and deployment**, set **Source** to **GitHub Actions**

Once configured, every push to the `main` branch will automatically build and deploy your site to GitHub Pages.
