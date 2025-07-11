/**
 * Import function triggers from their respective submodules:
 */
// const { auth } = require('firebase-functions');
/*
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// Importa o Firebase Admin SDK
const admin = require("firebase-admin");
// Importa o gatilho de autenticação de bloqueio (V2)
const {beforeUserSignedIn} = require("firebase-functions/v2/identity");
// Importa HttpsError (V2)
const {HttpsError} = require("firebase-functions/v2/https");

// Inicializa o Admin SDK para acessar os serviços do Firebase
admin.initializeApp();

/**
 * Função de bloqueio que é acionada antes de um usuário fazer login.
 * Verifica se uma conta com Email/Senha já existe e, se sim,
 * bloqueia qualquer tentativa de login que não seja com Email/Senha.
 */
exports.beforeSignIn = beforeUserSignedIn(async (event) => {
  // --- LOG DO OBJETO event.data COMPLETO PARA DEPURAR ---
  console.log(`[BeforeSignIn] event.data COMPLETO: ${
    JSON.stringify(event.data, null, 2)}`);

  const email = event.data.email;

  // Extrai o provedor da tentativa de login a partir de providerData.
  // IMPORTANTE: Assumimos que providerData[0]
  //  existe e é o provedor da tentativa atual.
  const currentAttemptProviderId = event.data.providerData?.[0]?.providerId;

  // --- LOGS INICIAIS ---
  console.log(`[BeforeSignIn] Tentativa de login/registro para: ${email}`);
  console.log(`[BeforeSignIn] Provedor da tentativa atual (via ` +
    `event.data.providerData[0].providerId): ${currentAttemptProviderId}`);

  if (!email) {
    console.log("[BeforeSignIn] Email não presente, permitindo login.");
    return;
  }

  try {
    const userRecord = await admin.auth().getUserByEmail(email);
    console.log(`[BeforeSignIn] Usuário encontrado: ${userRecord.uid}`);

    const existingProviders = userRecord.providerData.map((pd) =>
      pd.providerId);
    console.log(`[BeforeSignIn] Provedores existentes no registro do usuário ` +
      `(${email}): ${existingProviders.join(", ")}`);

    const hasPasswordProvider = existingProviders.includes("password");

    // --- LOGS DA CONDIÇÃO DE BLOQUEIO ---
    console.log(`[BeforeSignIn] hasPasswordProvider: ${hasPasswordProvider}`);
    console.log(`[BeforeSignIn] currentAttemptProviderId: ${
      currentAttemptProviderId}`);
    console.log(`[BeforeSignIn] Condição de bloqueio (hasPasswordProvider &&
      currentAttemptProviderId !== "password"): ${hasPasswordProvider &&
      currentAttemptProviderId !== "password"}`);

    // LÓGICA DE BLOQUEIO FINAL:
    // Se o usuário já possui um provedor de "password" (email/senha)
    // E o provedor que está sendo usado NESTA tentativa NÃO É "password"
    if (hasPasswordProvider && currentAttemptProviderId !== "password") {
      console.log(`[BeforeSignIn] BLOQUEANDO: Conflito detectado. ` +
        `Usuário tem senha e não está usando provedor de senha.`);
      throw new HttpsError(
          "already-in-use",
          "Uma conta com este e-mail já existe cadastrada com Email/Senha. " +
          "Por favor, faça login com sua senha ou use a recuperação de senha.",
      );
    }
    console.log(`[BeforeSignIn] Nenhuma condição de bloqueio detectada para ${
      email}. Permitindo login.`);
    return;
  } catch (error) {
    if (error.code === "auth/user-not-found") {
      console.log(`[BeforeSignIn] Usuário ${email} não encontrado no Auth. ` +
        `Permitindo login/registro.`);
      return;
    }
    console.error("Erro inesperado na Cloud Function beforeSignIn:", error);
    throw new HttpsError(
        "internal",
        "Erro interno no processo de autenticação.",
    );
  }
});
