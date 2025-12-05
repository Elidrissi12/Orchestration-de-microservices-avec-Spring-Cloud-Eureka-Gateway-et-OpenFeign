package ma.voiture.Repository;

import ma.voiture.entities.Voiture;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VoitureRepository extends JpaRepository<Voiture, Long> {
    // Méthode pour trouver les voitures par l'ID du client
    List<Voiture> findByClientId(Long clientId);
}
