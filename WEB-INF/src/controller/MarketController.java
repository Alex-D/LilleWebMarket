package src.controller;


import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import framework.Controller;

import src.entity.Market;
import src.entity.MarketRepository;
import src.entity.UserStock;
import src.entity.UserStockRepository;



public class MarketController extends Controller
{
    public void showAction(HttpServletRequest request, HttpServletResponse response) throws Exception
    {
        Market m = getRepository(request).findOneById(request.getParameter("id"));
        request.setAttribute("market", m);

        render(
            "market:show",
            request,
            response,
            "Marché : " + (request.getParameter("rev") != null ? m.getTitleRev() : m.getTitle())
        );
    }

    public void createAction(HttpServletRequest request, HttpServletResponse response) throws Exception
    {
        if(request.getMethod().equals("POST")){
            Market m = new Market();
            m.hydrate(request);
            int id = getRepository(request).create(m);
            redirect(response, request.getContextPath() + "/market/show?id=" + id);
        } else {
            render("market:create", request, response, "Créer un marché");
        }
    }

    public void buyAction(HttpServletRequest request, HttpServletResponse response) throws Exception
    {
        // Récupèrer l'id du market
        int marketId = Integer.parseInt(request.getParameter("id"));

        if(request.getMethod().equals("POST")){
            // Crée un objet UserStock
            UserStock stock = new UserStock();
            stock.setMarketId(marketId);
            stock.setLogin(getUser(request).getLogin());
            stock.setAssertion(request.getParameter("rev") == null);

            // Récupérer les valeurs du formulaire
            stock.hydrate(request);

            // Récupérer le UserStockRepository
            UserStockRepository stockRepo = ((UserStockRepository) getManager(request).getRepository("UserStock"));

            // Rechercher les UserStock inverses dont le prix est inférieur (ordre : prix DESC, date DESC)
            // au prix de l'UserStock en création (SELECT SQL)
            stockRepo.findPurchasable(marketId, stock.getAssertion(), stock.getPrice());

            // Pour chaque UserStock capable de vendre au prix demandé
                // Augmenter la valeur nbSold du UserStock débiteur d'autant que possible (UPDATE SQL)
                // Augmenter la valeur nbBuy du UserStock en création de cette même valeur
                // Retirer price * cette valeur au cash de l'User

            // Mettre à jour le cash de l'User (UPDATE SQL)

            // Sauvegarder le nouvel UserStock (INSERT SQL)

            // Afficher un message de confirmation
            addFlash(request, "success", "Achat effectué");
        }

        // Rediriger vers la page du marché
        redirect(response, request.getContextPath() + "/market/show?id=" + marketId);
    }



    private MarketRepository getRepository(HttpServletRequest request) throws Exception
    {
        return ((MarketRepository) getManager(request).getRepository("Market"));
    }
}